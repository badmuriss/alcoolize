# 🍻 Alcoolize - Drinking Games App

<div align="center">

**🌐 Languages:** [English](README.md) | [Português](README.pt-br.md)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-lightgrey?style=for-the-badge)

**O seu drinking game** - A collection of interactive party games to spice up your gatherings!

[📱 Try it now](#-getting-started) • [🎮 Games](#-available-games) • [🛠️ Contributing](#-contributing) • [📄 License](#-license)

</div>

---

## 🎯 About

Alcoolize is a **cross-platform Flutter app** featuring a curated collection of drinking games designed to bring people together and create memorable moments at parties and social gatherings. With a clean, intuitive interface and customizable gameplay, it's the perfect companion for your next celebration!

### ✨ Key Features

- 🎲 **8 Different Games** - From classic "Never Have I Ever" to unique "Medusa" 
- ⚙️ **Game Probability Control** - Adjust how often each game appears
- ✏️ **Custom Content Editor** - Edit questions and words for each game
- 🎨 **Modern UI/UX** - Clean, responsive design that works on all devices
- 🔧 **Flexible Settings** - Enable/disable games based on your group
- 💾 **Local Storage** - All customizations persist between sessions
- 🌐 **Multi-platform** - Android, iOS, Web, Windows, macOS, Linux

---

## 🎮 Available Games

| Game | Description | Players |
|------|-------------|---------|
| 🃏 **Cards** | Challenge cards with individual or group tasks | 2+ |
| 🚫 **Forbidden Word** | Don't say the forbidden word during the round | 3+ |
| 👁️ **Medusa** | Look up simultaneously - eye contact = drink! | 4+ |
| 🙈 **Never Have I Ever** | Classic drinking game with custom questions | 3+ |
| 🤔 **Paranoia** | Whispered questions with mysterious answers | 4+ |
| 🎯 **Most Likely To** | Vote on who's most likely to... | 3+ |
| 🔄 **Roulette** | Spin the wheel of fortune (and drinks) | 2+ |
| 🔤 **Mystery Verb** | Guess the hidden verb through creative questions | 4+ |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.5.3 or higher)
- Dart SDK (3.5.3 or higher)
- For mobile development: Android Studio / Xcode
- For web deployment: Any modern web browser

### 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/badmuriss/alcoolize.git
   cd alcoolize
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### 🏗️ Building for Production

#### Android APK
```bash
# Debug version
flutter build apk --debug

# Release version (requires signing)
flutter build apk --release
```

#### iOS App
```bash
flutter build ios --release
```

#### Web App
```bash
flutter build web --release
```

The built web app will be in `build/web/` and can be deployed to any static hosting service.

---

## 🎨 Customization

### 🎯 Game Probability Settings
Adjust how frequently each game appears in the rotation:
- Navigate to **Settings** → **Adjust Probabilities**
- Use sliders to set probability weights
- Total must equal 100%

### ✏️ Content Editor
Personalize questions and words for each game:
- Go to **Settings** → **Edit Questions/Words**
- Add, modify, or remove content
- Changes are saved locally and persist between sessions

### 🎪 Adding New Games
The app uses a modular architecture. To add a new game:

1. Create a new screen extending `BaseGameScreen`
2. Implement required methods (`gameColor`, `gameTitle`, `gameIcon`, etc.)
3. Add your game to `GameHandler.games` list
4. Create corresponding question/word assets

---

## 🛠️ Development

### 📁 Project Structure
```
lib/
├── main.dart                 # App entry point
└── src/
    ├── base_game_screen.dart  # Base class for all games
    ├── game_handler.dart      # Game logic and navigation
    ├── *_screen.dart         # Individual game screens
    ├── settings/             # App settings and configuration
    └── utils/                # Utility classes and helpers
```

### 🧪 Running Tests
```bash
flutter test
```

### 🎯 Code Quality
The project uses Flutter lints for code quality:
```bash
flutter analyze
```

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### 🐛 Bug Reports
- Use the [issue tracker](https://github.com/badmuriss/alcoolize/issues)
- Include steps to reproduce
- Mention your device/platform

### 💡 Feature Requests
- Check existing issues first
- Describe the feature and its benefits
- Consider implementation complexity

### 🔧 Pull Requests
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following the existing code style
4. Run tests and ensure they pass
5. Commit with clear messages: `git commit -m 'Add amazing feature'`
6. Push to your branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

### 📝 Development Guidelines
- Follow [Flutter's style guide](https://dart.dev/guides/language/effective-dart)
- Keep user-facing text in Portuguese (translation support coming soon)
- Write tests for new features
- Update documentation as needed

---

## 🌐 Deployment

The project includes automated deployment via Git hooks:
- Commits automatically trigger web builds
- Built app is pushed to `gh-pages` branch
- Can be deployed to GitHub Pages, Netlify, Vercel, etc.

### Manual Web Deployment
```bash
flutter pub global activate peanut
flutter pub global run peanut
git push origin gh-pages
```

---

## 📱 Download & Play

### Web Version
🌐 **[Play in Browser](https://alcoolize.outis.com.br/)** - *Available Now!*

### Mobile Apps
📱 Android APK and iOS App Store releases coming soon!

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Community Contributors** - For making this project better
- **Party People** - For testing and providing feedback!

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Alcoolize

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

**🍻 Made with ❤️ for unforgettable nights 🍻**

⭐ **Star this repo if you like it!** ⭐

</div>