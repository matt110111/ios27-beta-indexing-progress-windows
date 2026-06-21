# 更新日志

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
