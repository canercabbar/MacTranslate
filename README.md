<h1 align="center">Mac Translate</h1>

<div align="center">
  <img src="https://github.com/canercabbar/translate/blob/main/media/translate.png?raw=true" width="96" alt="App Icon" />
</div>

<p align="center">
  A lightweight, floating Google Translate panel for macOS accessible straight from your menu bar.
</p>

<div align="center">
  <img src="https://github.com/canercabbar/translate/blob/main/media/mac-translate-app.jpg?raw=true" alt="App Screenshot" />
</div>

---

## Features

- **Menu Bar Integration:** Instant floating panel over any app without cluttering the Dock.
- **Embedded Web UI:** Clean, distraction-free Google Translate interface powered by `WKWebView`.
- **Auto-Dismiss:** Seamlessly auto-hides when clicking outside the panel.
- **Movable & Floating:** Drag anywhere on the screen and keep it on top of all spaces/apps.
- **Built-in Shortcuts:** Efficient keyboard actions for clearing text, swapping languages, and audio listening.

---

## Installation

### Build from source

1. Clone the repository:
   ```bash
   git clone https://github.com/canercabbar/translate.git
   cd translate
   ```
2. Open `translate.xcodeproj` in Xcode.
3. Build & Run (`⌘ + R`).

> **First launch note:** If macOS blocks the app, navigate to **System Settings → Privacy & Security** and select **Open Anyway**.

---

## Configuration

Edit [`translate/Constants.swift`](translate/Constants.swift) to customize the panel size or default translation languages:

```swift
enum Constants {
    enum Window {
        static let defaultWidth: CGFloat = 550
        static let defaultHeight: CGFloat = 360
        static let cornerRadius: CGFloat = 16.0
    }
    
    enum Translation {
        static let sourceLanguage = "en"
        static let targetLanguage = "tr"
    }
}
```

| Setting | Description | Default |
|---|---|---|
| `defaultWidth` / `defaultHeight` | Panel dimensions in points | `550 × 360` |
| `cornerRadius` | Panel window corner radius | `16.0` |
| `sourceLanguage` | Default source language code (BCP-47) | `"en"` |
| `targetLanguage` | Default target language code (BCP-47) | `"tr"` |

---

## Keyboard Shortcuts (Inside Panel)

| Shortcut | Action |
|---|---|
| `Tab` | Dismiss panel focus and return to previous active app |
| `⌘ + A` | Select all text in the source input field |
| `⌘ + L` | Listen to speech (text-to-speech) for the source text |
| `⌘ + S` | Swap source ↔ target languages |
| `⌘ + Return` | Accept spelling suggestion / typo fix |
| `⌘ + Z` / `⌘ + R` | Undo / Redo text input |
| `⌘ + C` / `⌘ + V` / `⌘ + X` | Standard Copy, Paste, and Cut |

---

## Requirements

- macOS 14.0 Sonoma or later
- Xcode 15 or later
- Active internet connection

---

## License & Contribution

Contributions and pull requests are welcome. Feel free to open an issue for bug reports or feature requests.
