<<<<<<< HEAD
# KUPKOP

KUPKOP is a Flutter mobile app for family care workflows. The current build includes the onboarding screen, sign-in screen, and forgot-password screen using a playful Duolingo-inspired visual style.

## Tech Stack

- Flutter
- Dart
- Firebase packages prepared through `firebase_core`
- Android physical-device workflow over USB

## Current Screens

- Welcome / getting started screen
- Sign in screen
- Forgot password screen

## Requirements

- Flutter SDK
- Android SDK platform tools
- Java JDK
- A USB-connected Android phone with USB debugging enabled

## Run Locally

Clone the repository, install dependencies, then run the app:

```powershell
flutter pub get
flutter devices
flutter run
```

If your Android phone does not appear in `flutter devices`, check:

- Developer Options is enabled on the phone
- USB debugging is enabled
- The USB debugging prompt was accepted on the phone
- The USB cable supports data transfer

## Useful Commands

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

## Firebase

Firebase CLI and FlutterFire CLI are intended for this project, but Firebase project configuration is not committed yet. After choosing a Firebase project, run:

```powershell
firebase login
flutterfire configure
```

This will generate Firebase configuration files such as `lib/firebase_options.dart`.

## Project Structure

```text
lib/          Flutter app source
src/images/   App image assets
src/fonts/    App font assets
test/         Widget tests
android/      Android platform project
designs md/   Design notes and references
```

## Notes

Generated Flutter build output is ignored by git. Do not commit `build/`, `.dart_tool/`, or local IDE/cache files.
=======
# KupKop
An app for the one that care but don't have the time
>>>>>>> 121e3895b5e39c3f35b82f7bec27d01a3f27465b
