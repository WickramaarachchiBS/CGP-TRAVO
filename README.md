# CGP-TRAVO

A Flutter-based travel application that helps users discover and explore destinations across different districts.

## Features

* Browse destinations by district
* View detailed information about each location
* Interactive maps to explore locations
* Location images and descriptions
* Cross-platform support (Android, iOS, Web, Windows, Linux, macOS)

## Getting Started

### Prerequisites

* Flutter (latest stable version)
* Firebase account (for Firestore database)
* Android SDK / Xcode (for mobile development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/CGP-TRAVO.git
   cd CGP-TRAVO
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   * Create a new Firebase project
   * Enable Firestore Database
   * Add your Flutter application to the Firebase project
   * Download and place the google-services.json (for Android) and GoogleService-Info.plist (for iOS) in the appropriate directories

4. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

* `lib/`: Contains the Dart code for the application
  * `screens/`: UI screens for the application
  * `Data/`: Data models including Place class
* `assets/`: Contains static assets like images
* `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`: Platform-specific code

## Firebase Structure

The application uses Firebase Firestore with the following structure:

```
places
└── districts
    └── [district_name]
        └── [location_documents]
```

Each location document contains:
* name
* address
* imagePath
* latitude
* longitude
* description

## Building for Different Platforms

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

### Windows
```bash
flutter build windows
```

### Linux
```bash
flutter build linux
```

### macOS
```bash
flutter build macos
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [Cloud Firestore](https://firebase.google.com/docs/firestore)