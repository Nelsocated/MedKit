# MedKit

A home medicine cabinet tracker. Families list the medicines they have at home, and MedKit warns when one is expired, expiring soon or running low.

## Features

- Add, edit and delete medicines with expiry date, quantity and who they are for
- Dashboard of expired, expiring within 30 days and low stock medicines
- Search and filter the list by name, status and family member
- Look up a medicine's purpose, dosage and warnings from the openFDA drug label API
- Data is saved on the device

## Packages

- `provider` for state management
- `http` for the openFDA API
- `shared_preferences` for saving medicines on the device
- `intl` for date formatting
- `flutter_launcher_icons` and `flutter_native_splash` for the app icon and splash screen

## Setup

Requires Flutter 3.44 or newer.

```bash
git clone https://github.com/Nelsocated/MedKit.git
cd MedKit
flutter pub get
```

## Run

In Chrome (the fixed port keeps saved medicines between runs):

```bash
flutter run -d chrome --web-port 8080
```

On an Android device:

```bash
flutter run
```

## Build the APK

Needs the Android SDK (Android Studio or the command-line tools).

```bash
flutter build apk --release
```

The APK is saved to `build/app/outputs/flutter-apk/app-release.apk`. The release build is signed with the debug key.

## Member

Nelson Lago III
