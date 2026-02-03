# Kanchi Note

A cross-platform desktop application for managing Danish vocabulary and phrases. Built with Flutter for Linux and macOS.

## Features

- **Phrase Management**: Store Danish phrases with English meanings and personal notes
- **Auto-Translation**: Click ✨ to fetch English translations via MyMemory API
- **AI-Powered Notes**: Click ✨ to generate contextual notes via Google Gemini API
- **Text-to-Speech**: Listen to Danish pronunciation with the built-in TTS
- **System Tray**: Runs in background, always ready when needed
- **Search**: Filter phrases across all columns in real-time
- **Offline Storage**: All data stored locally in SQLite

## Screenshots

See [MOCKUP.md](MOCKUP.md) for UI mockups.

## Installation

### Linux Dependencies

```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libkeybinder-3.0-dev libayatana-appindicator3-dev libspeechd-dev
```

### Build & Run

```bash
# Install Flutter dependencies
flutter pub get

# Generate database code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run with Gemini AI features enabled
GEMINI_API_KEY=your_key flutter run
```

### Build for Release

```bash
# Linux
flutter build linux --release

# macOS
flutter build macos --release
```

## Usage

1. Launch the app
2. Click **+ Add** to add a new phrase
3. Enter a Danish phrase
4. Click ✨ next to Meaning to auto-translate
5. Click ✨ next to My Note to generate an AI note (requires Gemini API key)
6. Click **Submit** to save

### Inline Editing

Click any cell in the table to edit it directly. When editing a phrase, the meaning is automatically re-translated.

### Audio Pronunciation

Click the 🔊 icon next to any phrase to hear the Danish pronunciation.

## Tech Stack

- **Framework**: Flutter (Desktop)
- **Database**: SQLite via Drift
- **State Management**: Riverpod
- **Translation API**: MyMemory
- **AI Definitions**: Google Gemini
- **TTS**: flutter_tts (native OS engine)

## Documentation

- [REQUIREMENTS.md](REQUIREMENTS.md) - Full requirements specification
- [MOCKUP.md](MOCKUP.md) - UI mockups and design
- [CLAUDE.md](CLAUDE.md) - Development guidelines

## License

MIT
