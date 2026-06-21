<p align="right">
  <strong>English</strong> |
  <a href="README.zh-CN.md">中文</a>
</p>

# iOS 27 Beta Indexing Progress Checker for Windows

A simple tool for iOS 27 devices that show "Indexing in Progress" in Settings but do not show a percentage. It runs on **Windows** and **macOS**.

Connect your iPhone over USB, run the tool, and it will show the latest indexing percentage reported by the phone.

## Download

[Download ZIP (GitHub)](https://github.com/CZJ0219/ios27-beta-indexing-progress-windows/releases/latest/download/iOS_Indexing_Checker_Windows_NoPython.zip)

[Download ZIP (Tencent Weiyun)](https://share.weiyun.com/H5B7bCUz)

## How To Use (Windows)

1. Download and unzip `iOS_Indexing_Checker_Windows_NoPython.zip`.
2. Connect your iPhone with a USB cable.
3. Unlock the iPhone.
4. Tap "Trust This Computer" if the iPhone asks.
5. Open the Settings app on the iPhone.
6. Double-click `Start-iOS-Indexing-Checker.cmd`.
7. Choose English or Chinese.
8. Press Enter in the tool window when prompted.

## How To Use (macOS)

macOS talks to the iPhone through the built-in `usbmuxd`, so iTunes or the
Apple Devices app is not required. You do need Python 3.10+ (install with
`brew install python` or from [python.org](https://www.python.org/downloads/macos/);
the Command Line Tools' built-in Python 3.9 is too old).

1. Connect your iPhone with a USB cable.
2. Unlock the iPhone, and tap "Trust This Computer" if asked.
3. Open the Settings app on the iPhone.
4. Double-click `scripts/Start-iOS-Indexing-Checker.command`.
5. Choose English or Chinese.
6. Press Enter in the Terminal window when prompted.

See [docs/MAC_USER_GUIDE.md](docs/MAC_USER_GUIDE.md) for full macOS notes,
including the first-run Gatekeeper prompt.

When it works, you will see a line like this:

```text
iOS indexing progress: 85%
```

If a percentage does not appear immediately, leave the iPhone unlocked and wait a little longer.

## Requirements

- Windows 10 / 11, or macOS 12 or newer.
- An iPhone/iPad running iOS 27 beta (iPadOS 27 Beta).
- A USB cable that supports data transfer.
- **Windows:** Apple Devices or iTunes installed if this PC has never connected to an iPhone before.
- **macOS:** Python 3.10+ (`brew install python` or python.org). No iTunes/Apple Devices needed.

If the computer can't see the iPhone (File Explorer / Apple Devices / iTunes on Windows, or Finder on macOS), this tool will not be able to see it either.

## If It Seems Stuck

- Keep the iPhone unlocked.
- Keep the Settings app open on the iPhone.
- Confirm that you tapped "Trust This Computer".
- Unplug and reconnect the USB cable.
- Try another USB port or another cable.

## Privacy

The tool runs locally on your PC. It does not upload logs, collect telemetry, or connect to a server run by this project.

A local troubleshooting log may be created next to the tool. If you share that log publicly, remove device names, device IDs, Apple IDs, phone numbers, emails, and anything else you do not want to publish.

</details>

## Disclaimer

This is not an Apple tool and is not affiliated with Apple. Use it only with an iPhone you own or have permission to inspect.

## License

MIT License. See [LICENSE](LICENSE).
