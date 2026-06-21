# macOS User Guide

This tool also runs on macOS. If your iPhone shows "Indexing in Progress" in
Settings without a percentage, you can read the current percentage over USB
from your Mac.

macOS talks to the iPhone through the built-in `usbmuxd` service, so you do
**not** need iTunes or the Apple Devices app. The launcher sets up a small,
self-contained Python environment in this folder the first time you run it.

## Requirements

- macOS 12 or newer.
- An iPhone/iPad running iOS 27 beta (iPadOS 27 Beta).
- A USB cable that supports data transfer.
- Python 3.10 or newer. macOS does not ship Python by default; install it with
  [Homebrew](https://brew.sh) (`brew install python`) or from
  [python.org](https://www.python.org/downloads/macos/). **Note:** the Python
  3.9 bundled with the Xcode Command Line Tools is too old — `pymobiledevice3`
  needs 3.10+.

## How To Use

1. Connect your iPhone with a USB cable.
2. Unlock the iPhone.
3. Tap "Trust This Computer" if the iPhone asks.
4. Open the Settings app on the iPhone.
5. Double-click `Start-iOS-Indexing-Checker.command`.
6. Choose English or Chinese.
7. Press Enter in the Terminal window when prompted.

When it works, you will see a line like this:

```text
iOS indexing progress: 85%
```

If a percentage does not appear immediately, leave the iPhone unlocked and
wait a little longer.

### First-run security prompt

The first time you double-click a `.command` file, macOS Gatekeeper may refuse
to open it. If that happens, right-click (or Control-click) the file, choose
**Open**, then confirm. You only need to do this once.

If double-clicking does nothing, you can also run it from Terminal:

```bash
chmod +x Start-iOS-Indexing-Checker.command
./Start-iOS-Indexing-Checker.command
```

## "The iPhone log reader component could not be installed"

If setup fails with a `SyntaxError` mentioning `match` and a path containing
`.../Python3.framework/Versions/3.9/...`, the launcher is using the Command
Line Tools' Python 3.9, which is too old. Install Python 3.10+ and remove the
half-built environment so it rebuilds:

```bash
brew install python          # or install from python.org
rm -rf .ios-indexing-runtime  # run this in the folder with the launcher
```

Then double-click the launcher again. Newer versions of the launcher skip
Python 3.9 automatically and rebuild a stale environment for you.

## If It Seems Stuck

- Keep the iPhone unlocked.
- Keep the Settings app open on the iPhone.
- Confirm that you tapped "Trust This Computer".
- Run `idevice_id -l` (if installed) or check that the iPhone appears in
  Finder's sidebar — if the Mac cannot see the device, this tool cannot either.
- Unplug and reconnect the USB cable, or try another port or cable.

## Privacy

The tool runs locally on your Mac. It does not upload logs, collect telemetry,
or connect to a server run by this project.

A local `ios-indexing-checker.log` may be created next to the launcher. If you
share that log publicly, remove device names, device IDs (UDIDs), Apple IDs,
phone numbers, emails, and anything else you do not want to publish.
