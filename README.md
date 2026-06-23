# Human Typer

A tiny [AutoHotkey v2](https://www.autohotkey.com/) tool that types your own text into a focused field **the way a human would** — character by character, with natural speed variation and pauses — so it goes in as genuine keystrokes instead of a single paste.

Useful for fields that block or detect pasting, chat apps, forms, or anywhere you'd rather your text arrive as real typing.

## Features

- **Human-like typing** — per-character timing with random jitter, longer pauses after sentences (`.!?`), clause breaks (`,`), and new lines, plus the occasional "thinking" pause.
- **Adjustable speed** — set words per minute (defaults to 60 WPM).
- **Start delay** — a countdown gives you time to click into the target field before typing begins.
- **Progress bar** — live progress with words-typed / total and percentage.
- **Chat-friendly line breaks** — optional `Shift+Enter` for newlines so multi-line messages don't send early in chat apps.
- **Safe stop** — abort instantly with `Ctrl+F9`; typing also auto-pauses if the Human Typer window itself is focused.

## Requirements

- Windows
- [AutoHotkey v2.0](https://www.autohotkey.com/) — only needed to run the `.ahk` source. The compiled `.exe` from the [Releases](../../releases) page runs standalone with nothing to install.

## Usage

1. Run `human-typer.ahk` (with AutoHotkey v2 installed) **or** download and run `HumanTyper.exe` from [Releases](../../releases).
2. Paste your text into the box.
3. Set **Speed (WPM)** and the **Start delay (seconds)**.
4. (Optional) Tick **Shift+Enter for line breaks** if you're typing into a chat app where Enter sends the message.
5. Click **Start** (or press `F9`), then click into the target field during the countdown.
6. Watch the progress bar. Press `Ctrl+F9` any time to stop.

## Hotkeys

| Key        | Action            |
| ---------- | ----------------- |
| `F9`       | Start typing      |
| `Ctrl+F9`  | Stop / abort      |

## Building from source

Releases are built automatically by GitHub Actions on every version tag (e.g. `0.2`), which compiles the script with [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe) on a Windows runner and attaches `HumanTyper.exe` to the release. See [`.github/workflows/release.yml`](.github/workflows/release.yml).

To compile locally, open `human-typer.ahk` in Ahk2Exe (bundled with AutoHotkey v2) and compile.

## License

[MIT](LICENSE)
