# 更新日志

## 0.2.1 - 2026-06-21

- 修复 macOS 启动器在系统自带 Python 3.9（命令行工具）下安装 `pymobiledevice3` 失败的问题：现在要求 Python 3.10+，优先选择更新的解释器，并自动重建用旧版本创建的 venv。
- 启动器设置 `PYTHONUTF8` / `PYTHONIOENCODING`，避免 pip 字节码编译阶段因 stdout 无编码而崩溃（双击启动时常见）。
- 文档与 README 同步将 macOS 要求更新为 Python 3.10+，并新增对应排查说明。

## 0.2.0 - 2026-06-21

- 新增 macOS 支持：提供可双击的 `scripts/Start-iOS-Indexing-Checker.command` 一键启动器（双语 UI）。
- macOS 启动器在本地创建 venv 并安装 `pymobiledevice3`，通过系统 `usbmuxd` 连接 iPhone，无需 iTunes / Apple Devices。
- 新增 `docs/MAC_USER_GUIDE.md`，README（中英文）同步增加 macOS 使用说明与设备要求。

## 0.1.1 - 2026-06-17

- 增加英语 UI：打开工具后可先选择 English 或中文。
- 启动器和核心程序会根据所选语言显示对应提示、错误和完成文案。
- 离线 ZIP 包内的使用说明同步增加英文内容。

## 0.1.0 - 2026-06-16

- 初始公开版本。
- Windows 离线包，无需用户安装 Python。
- 支持读取 iOS 27 beta 设备日志中的 `PipelineCompleteness`。
- 启动器显示运行阶段和心跳，避免看起来像卡住。
- 同目录生成 `ios-indexing-checker.log` 方便排查。
- 已在 Windows + iOS 27.0 beta 真机上验证读取到 85% 索引进度。
