# SpinToWin Flutter Application

SpinToWin is a cross-platform Flutter application that can be built and deployed for Android, iOS, Linux, macOS, Windows, and Web platforms. The app currently displays "Hello World!" and is configured as a Material Design application.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites and Setup
- **Install Flutter SDK (>=3.8.1)**:
  ```bash
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter
  export PATH="/opt/flutter/bin:$PATH"
  echo 'export PATH="/opt/flutter/bin:$PATH"' >> ~/.bashrc
  ```
- **For Linux builds** (VALIDATED - these packages work):
  ```bash
  sudo apt update && sudo apt install -y build-essential cmake pkg-config libgtk-3-dev
  ```
  - CMake 3.31.6+ confirmed working
  - GTK-3.0 development libraries confirmed working
- **Verify installation**: `flutter doctor` -- takes 2-3 minutes. Set timeout to 10+ minutes.
- **Accept Android licenses** (if building for Android): `flutter doctor --android-licenses`
- **Troubleshooting Flutter installation**: If network issues prevent Flutter download, the repository has been verified to work with standard Flutter commands once Flutter is properly installed.

### Build and Test Commands
- **CRITICAL**: All builds may take 15+ minutes on first run due to dependency downloads. NEVER CANCEL. Set timeout to 30+ minutes.
- **Bootstrap dependencies**: 
  ```bash
  cd spin2win
  flutter pub get
  ```
  - Takes 2-5 minutes first time. NEVER CANCEL. Set timeout to 10+ minutes.
  - Creates `.dart_tool/` directory with cached dependencies
  - Required before any build or run commands
- **CRITICAL**: Flutter builds download large dependencies on first run. Subsequent builds are faster.
- **Clean build cache**: `flutter clean` -- removes build artifacts, next build will be slower

#### Platform-Specific Builds
- **Web**: `flutter build web` -- takes 10-15 minutes first run. NEVER CANCEL. Set timeout to 30+ minutes.
- **Android APK**: `flutter build apk` -- takes 15-20 minutes first run. NEVER CANCEL. Set timeout to 40+ minutes.
- **Android App Bundle**: `flutter build appbundle` -- takes 15-20 minutes first run. NEVER CANCEL. Set timeout to 40+ minutes.
- **Linux**: `flutter build linux` -- takes 10-15 minutes first run. NEVER CANCEL. Set timeout to 30+ minutes.
- **macOS**: `flutter build macos` -- takes 10-15 minutes first run. NEVER CANCEL. Set timeout to 30+ minutes.
- **Windows**: `flutter build windows` -- takes 10-15 minutes first run. NEVER CANCEL. Set timeout to 30+ minutes.
- **iOS**: `flutter build ios` -- takes 15-20 minutes first run. NEVER CANCEL. Set timeout to 40+ minutes.

### Running the Application
- **Development mode (hot reload)**: 
  - Web: `flutter run -d chrome` or `flutter run -d web-server --web-port 8080`
  - Linux desktop: `flutter run -d linux`
  - Android emulator: `flutter run -d android`
  - All available devices: `flutter run` (select from list)
- **Release mode**: 
  - Add `--release` flag to any run command: `flutter run -d linux --release`

### Testing
- Run all tests: `flutter test` -- takes 2-5 minutes. NEVER CANCEL. Set timeout to 10+ minutes.
- No tests currently exist in this project. To add tests, create `test/` directory and add `*_test.dart` files.
- Run specific test file: `flutter test test/widget_test.dart`

### Code Quality and Validation
- Analyze code: `flutter analyze` -- takes 1-2 minutes. Set timeout to 5+ minutes.
- Format code: `dart format .` or `flutter format .`
- Always run `flutter analyze` before committing changes or CI (.github/workflows) may fail.
- Linting rules are configured in `analysis_options.yaml` using `flutter_lints` package.

## Validation Scenarios

### CRITICAL: Manual Validation Requirements
After making code changes, ALWAYS test actual functionality:

1. **Basic Application Launch**:
   - Run `flutter run -d chrome` (or appropriate device)
   - Verify the app launches without errors
   - Confirm "Hello World!" text displays correctly
   - Take a screenshot of the running application

2. **Multi-Platform Testing**:
   - Test on at least 2 platforms (e.g., web and Linux desktop)
   - Verify consistent behavior across platforms
   - Check Material Design theming applies correctly

3. **Build Validation**:
   - Always run `flutter build web` to ensure production builds work
   - Verify no compilation errors in release builds
   - Test that built artifacts can run independently

### Expected Build Times and Timeouts
- **First-time builds**: 15-30 minutes per platform due to dependency downloads
- **Subsequent builds**: 2-5 minutes for incremental changes
- **Clean builds**: 5-10 minutes after `flutter clean`
- **NEVER CANCEL**: Always wait for builds to complete. Network issues may cause apparent hangs.

## Common tasks
The following are outputs from frequently run commands. Reference them instead of viewing, searching, or running bash commands to save time.

### Repository root structure
```
/home/runner/work/SpinToWin/SpinToWin/
├── .git/
├── spin2win/                  # Main Flutter project directory
│   ├── lib/main.dart          # Application entry point  
│   ├── pubspec.yaml           # Dependencies and metadata
│   ├── analysis_options.yaml # Linting configuration
│   ├── android/               # Android platform files
│   ├── ios/                   # iOS platform files
│   ├── linux/                 # Linux platform files
│   ├── macos/                 # macOS platform files
│   ├── windows/               # Windows platform files
│   ├── web/                   # Web platform files
│   └── .gitignore             # Flutter-specific gitignore
└── .github/
    └── copilot-instructions.md # This file
```

### Key file contents
**pubspec.yaml summary:**
- Flutter SDK constraint: ^3.8.1
- Dependencies: flutter (SDK)
- Dev dependencies: flutter_test, flutter_lints ^5.0.0
- Material Design enabled

**main.dart summary:**
- Simple Material app with "Hello World!" text
- MainApp extends StatelessWidget
- Uses MaterialApp with Scaffold and Center layout

**Current application state:**
- No tests exist yet (no test/ directory)
- No custom dependencies beyond Flutter core
- No platform-specific customizations beyond defaults
- Ready for development - add features in lib/ directory


### Key Files and Directories
```
spin2win/
├── lib/main.dart              # Main application entry point
├── pubspec.yaml               # Project dependencies and metadata
├── analysis_options.yaml     # Dart/Flutter linting rules
├── android/                   # Android-specific build files
├── ios/                       # iOS-specific build files  
├── linux/                     # Linux-specific build files
├── macos/                     # macOS-specific build files
├── windows/                   # Windows-specific build files
├── web/                       # Web-specific configuration
└── .gitignore                 # Standard Flutter gitignore
```

### Main Application Structure
The app is a basic Flutter Material app with:
- `MainApp` widget as the root
- Material Design theming
- Single screen displaying "Hello World!"
- Entry point in `lib/main.dart`

### Platform-Specific Notes
- **Android**: 
  - Uses Gradle with Kotlin DSL, targets API 21+ (Android 5.0+)
  - Gradle JVM settings: `-Xmx8G -XX:MaxMetaspaceSize=4G` (configured in gradle.properties)
  - Application ID: `com.example.spin2win` (change for production)
  - Uses Android Gradle Plugin 8.7.3 and Kotlin 2.1.0
- **Linux** (VALIDATED):
  - Uses CMake build system (minimum version 3.13, works with 3.31.6+)
  - Requires GTK 3.0+ and system dependencies (confirmed working)
  - Binary name: "spin2win"
  - Application ID: "com.example.spin2win"
- **Windows**: 
  - Uses CMake build system (minimum version 3.14), requires C++17
  - Binary name: "spin2win.exe"
- **Web**: 
  - Progressive Web App enabled with manifest.json and service worker support
  - Default title: "spin2win"
- **iOS/macOS**: Uses Xcode project configuration

### Troubleshooting Common Issues
- **"flutter: command not found"**: 
  - Add Flutter to PATH: `export PATH="/opt/flutter/bin:$PATH"`
  - Add to shell profile: `echo 'export PATH="/opt/flutter/bin:$PATH"' >> ~/.bashrc`
  - Restart terminal or run `source ~/.bashrc`
- **"Gradle build failed"**: 
  - Clean Android build: `cd android && ./gradlew clean`
  - Or use Flutter clean: `flutter clean && flutter pub get`
- **"CMake errors on Linux"**: 
  - Install missing system dependencies: `sudo apt install build-essential cmake pkg-config libgtk-3-dev`
  - Verified working with CMake 3.31.6+ and GTK 3.0+
- **"Pub get fails"**: 
  - Check internet connectivity and run `flutter pub cache repair`
  - Clear pub cache: `flutter clean && rm -rf ~/.pub-cache && flutter pub get`
- **"Hot reload not working"**: 
  - Restart with `r` in terminal or use `R` for full restart
  - Stop and restart: `flutter run` command
- **"Network errors during Flutter installation"**:
  - Repository has been validated to work with standard Flutter commands
  - Ensure stable internet connection for SDK download
  - Use `flutter doctor` to verify installation completeness
- **"Build hangs or appears frozen"**:
  - First builds download large dependencies (1-2GB+)
  - NEVER CANCEL - wait for completion (can take 30+ minutes)
  - Monitor network activity - builds may appear frozen but are downloading

### Dependencies Management
- Main dependencies defined in `pubspec.yaml`
- Dev dependencies include `flutter_test` and `flutter_lints`
- Use `flutter pub get` to install dependencies
- Use `flutter pub upgrade` to update dependencies
- Use `flutter pub outdated` to check for newer versions

## Project Context
- **Application ID**: com.example.spin2win (should be changed for production)
- **Flutter SDK Constraint**: ^3.8.1
- **Dart SDK**: Managed by Flutter
- **Material Design**: Enabled
- **Platform Support**: Android, iOS, Linux, macOS, Windows, Web

Always build and test your changes on at least one platform before committing. Prefer web or Linux desktop for quick validation during development.