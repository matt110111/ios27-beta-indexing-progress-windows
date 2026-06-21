#!/bin/bash
# One-click launcher for the macOS iOS indexing checker.
#
# This launcher keeps setup local to this folder:
# - lets the user choose English or Chinese
# - creates a local Python virtual environment
# - installs the iPhone log reader component (pymobiledevice3)
# - runs the core reader against a USB-connected iPhone
#
# macOS talks to the iPhone through the system usbmuxd, so iTunes or the
# Apple Devices app is not required.

set -u

# Resolve the directory this script lives in, even when double-clicked.
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
    SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
    [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$DIR/$SCRIPT_SOURCE"
done
ROOT="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
cd "$ROOT" || exit 1

RUNTIME_ROOT="$ROOT/.ios-indexing-runtime"
VENV_PATH="$RUNTIME_ROOT/venv"
VENV_PY="$VENV_PATH/bin/python"
LOG_PATH="$ROOT/ios-indexing-checker.log"

# Find the core reader, whether it sits next to this launcher (offline
# package) or in the repository's src/ folder (developer checkout).
CORE_SCRIPT=""
for candidate in "$ROOT/IosIndexingProgress.py" "$ROOT/src/IosIndexingProgress.py" "$ROOT/../src/IosIndexingProgress.py"; do
    if [ -f "$candidate" ]; then
        CORE_SCRIPT="$candidate"
        break
    fi
done

DURATION_SECONDS="${DURATION_SECONDS:-300}"
DEVICE_ID="${DEVICE_ID:-}"
RAW="${RAW:-0}"
NO_PROMPT="${NO_PROMPT:-0}"
LANGUAGE="${LANGUAGE:-}"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >>"$LOG_PATH"
}

# --- Localized strings -------------------------------------------------------

t() {
    local key="$1"
    local arg="${2:-}"
    case "$LANGUAGE:$key" in
        en:title) echo "iOS Indexing Checker for macOS" ;;
        zh:title) echo "iOS 索引进度查询工具（macOS）" ;;
        en:logFile) echo "Log file: $LOG_PATH" ;;
        zh:logFile) echo "日志文件：$LOG_PATH" ;;
        en:beforeStart) echo "Before you start:" ;;
        zh:beforeStart) echo "准备好之后：" ;;
        en:prep1) echo "1. Connect the iPhone by USB" ;;
        zh:prep1) echo "1. 用 USB 插上 iPhone" ;;
        en:prep2) echo "2. Unlock the iPhone and tap \"Trust This Computer\"" ;;
        zh:prep2) echo "2. 解锁 iPhone，并点 信任此电脑" ;;
        en:prep3) echo "3. Open Settings on the iPhone" ;;
        zh:prep3) echo "3. 在 iPhone 上打开 设置" ;;
        en:ready) echo "Press Enter when ready" ;;
        zh:ready) echo "准备好后按 Enter 开始" ;;
        en:noPython) echo "Python 3.9+ was not found. Install it with 'brew install python' or from python.org, then run this tool again." ;;
        zh:noPython) echo "没有找到 Python 3.9+。请用 'brew install python' 或到 python.org 安装后，重新运行本工具。" ;;
        en:createRuntime) echo "Creating local Python runtime ($arg)..." ;;
        zh:createRuntime) echo "正在创建本地运行环境 Python（$arg）..." ;;
        en:createRuntimeFailed) echo "Could not create the local runtime." ;;
        zh:createRuntimeFailed) echo "创建本地运行环境失败。" ;;
        en:installComponent) echo "Installing the iPhone log reader component..." ;;
        zh:installComponent) echo "正在安装 iPhone 日志读取组件..." ;;
        en:installComponentFailed) echo "The iPhone log reader component could not be installed. Check your network connection and try again." ;;
        zh:installComponentFailed) echo "iPhone 日志读取组件安装失败。请检查网络后再试。" ;;
        en:missingCoreScript) echo "Core script was not found: $arg" ;;
        zh:missingCoreScript) echo "找不到核心脚本：$arg" ;;
        en:starting) echo "Starting the core reader..." ;;
        zh:starting) echo "正在启动核心程序..." ;;
        en:success) echo "Done: iOS indexing progress was found." ;;
        zh:success) echo "完成：已经读到 iOS 索引进度。" ;;
        en:noProgress) echo "No indexing progress was found this time. Keep the iPhone unlocked, keep Settings open, and run the tool again." ;;
        zh:noProgress) echo "这次没有读到索引进度日志。保持 iPhone 解锁并打开 设置，可以再运行一次。" ;;
        en:finishedWithCode) echo "The tool finished with exit code: $arg" ;;
        zh:finishedWithCode) echo "工具结束，退出码：$arg" ;;
        en:close) echo "Press Enter to close" ;;
        zh:close) echo "按 Enter 关闭" ;;
        *) echo "$key" ;;
    esac
}

step() {
    printf '\n%s\n' "$1"
    log "$1"
}

wait_user() {
    [ "$NO_PROMPT" = "1" ] && return 0
    local prompt="$1"
    read -r -p "$prompt" _ || true
}

select_language() {
    clear
    echo "iOS Indexing Checker for macOS"
    echo ""
    echo "Choose language / 选择语言"
    echo "1. English"
    echo "2. 中文"
    echo ""
    while true; do
        read -r -p "Enter 1 or 2 / 请输入 1 或 2: " choice
        case "$(echo "$choice" | tr -d '[:space:]')" in
            1) LANGUAGE="en"; return ;;
            2) LANGUAGE="zh"; return ;;
            *) echo "Please enter 1 or 2. / 请输入 1 或 2。" ;;
        esac
    done
}

# --- Python discovery and runtime --------------------------------------------

find_python() {
    local probe='import sys; sys.exit(0 if sys.version_info[:2] >= (3, 9) else 1)'
    for cmd in python3 python; do
        if command -v "$cmd" >/dev/null 2>&1; then
            if "$cmd" -c "$probe" >/dev/null 2>&1; then
                echo "$cmd"
                return 0
            fi
        fi
    done
    return 1
}

has_pymobiledevice3() {
    "$1" -c "import importlib.util, sys; sys.exit(0 if importlib.util.find_spec('pymobiledevice3') else 1)" >/dev/null 2>&1
}

ensure_runtime() {
    if [ -x "$VENV_PY" ] && has_pymobiledevice3 "$VENV_PY"; then
        return 0
    fi

    local host_python
    if ! host_python="$(find_python)"; then
        step "$(t noPython)"
        return 1
    fi

    if [ ! -x "$VENV_PY" ]; then
        local version
        version="$("$host_python" -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null)"
        step "$(t createRuntime "$version")"
        mkdir -p "$RUNTIME_ROOT"
        if ! "$host_python" -m venv "$VENV_PATH"; then
            step "$(t createRuntimeFailed)"
            return 1
        fi
    fi

    step "$(t installComponent)"
    "$VENV_PY" -m pip install --upgrade pip >/dev/null 2>&1
    local wheels="$ROOT/wheels"
    if [ -d "$wheels" ]; then
        "$VENV_PY" -m pip install --no-index --find-links "$wheels" -U pymobiledevice3
    else
        "$VENV_PY" -m pip install -U pymobiledevice3
    fi
    if [ $? -ne 0 ]; then
        step "$(t installComponentFailed)"
        return 1
    fi
}

start_checker() {
    if [ -z "$CORE_SCRIPT" ]; then
        step "$(t missingCoreScript "IosIndexingProgress.py")"
        return 1
    fi

    step "$(t starting)"
    local args=("$CORE_SCRIPT" "--duration" "$DURATION_SECONDS" "--language" "$LANGUAGE")
    [ -n "$DEVICE_ID" ] && args+=("--udid" "$DEVICE_ID")
    [ "$RAW" = "1" ] && args+=("--raw")

    log "Core command: $VENV_PY ${args[*]}"
    "$VENV_PY" "${args[@]}" 2>&1 | tee -a "$LOG_PATH"
    return "${PIPESTATUS[0]}"
}

# --- Main --------------------------------------------------------------------

if [ -z "$LANGUAGE" ]; then
    if [ "$NO_PROMPT" = "1" ]; then
        LANGUAGE="en"
    else
        select_language
    fi
fi

clear
log "macOS launcher started. Language=$LANGUAGE"
echo "$(t title)"
echo ""
echo "$(t logFile)"
echo ""
echo "$(t beforeStart)"
echo "$(t prep1)"
echo "$(t prep2)"
echo "$(t prep3)"
echo ""
wait_user "$(t ready)"

code=0
if ensure_runtime; then
    start_checker
    code=$?
else
    code=1
fi

echo ""
if [ "$code" = "0" ]; then
    echo "$(t success)"
elif [ "$code" = "3" ]; then
    echo "$(t noProgress)"
else
    echo "$(t finishedWithCode "$code")"
fi

echo ""
wait_user "$(t close)"
exit "$code"
