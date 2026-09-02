# HyipRio Mobile App

Flutter mobile application for the HyipRio user panel. Version 1.3 supports authentication, biometric login, email/2FA verification, deposits, withdrawals, wallet exchange, investments, KYC, notifications, referrals, rewards, tickets, transaction history, global license validation, and license retry/reinitialization.

## Requirements

- Flutter SDK 3.38.5 or a compatible stable release
- Dart SDK 3.10.4 or newer within the project constraint
- Android Studio/Xcode for platform builds
- Android SDK and a configured emulator or physical device
- Firebase configuration for Android and iOS
- Existing Android release keystore for publishing signed APKs

## Getting started

```bash
flutter pub get
flutter analyze
flutter run
```

The API base URL is configured in:

```text
lib/src/backend/links.dart
```

Replace only the `baseUrl` value with your own Laravel backend domain:

```dart
static const String baseUrl = "https://your-domain.com/api";
```

The backend must expose the Hyiprio Laravel API under the `/api` path. Do not commit passwords, tokens, keystore
files, or other secrets.

## Main commands

```bash
# Format Dart files
dart format lib

# Static analysis
flutter analyze

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

Build artifacts are generated under `build/` and should not be committed.

## Project structure

```text
lib/
├── main.dart                         # Application entry point
└── src/
    ├── app/                          # Bindings and GetX routes
    ├── backend/                      # Dio clients, APIs, auth persistence
    ├── common/                       # Shared controllers, models, widgets
    ├── presentation/screen/          # Feature screens and controllers
    ├── services/                     # Firebase, notifications, biometrics
    └── utils/                        # Constants, validation, logging, helpers
assets/                               # Images, icons, fonts
android/                              # Android project configuration
ios/                                  # iOS project configuration
```

The application uses GetX for dependency injection, routing, and reactive state management. API access is separated into public and authenticated clients under `lib/src/backend/`.

## Authentication and security

- Auth tokens are stored with `flutter_secure_storage`.
- Biometric credentials are stored securely; passwords are not stored in `SharedPreferences`.
- Production network logging is disabled and sensitive values are redacted in debug logs.
- OTP validation is performed before sending verification requests.
- Logout clears the local authentication session even if the server logout request fails.
- Payment WebView navigation allows HTTPS URLs only.

Never commit:

- `android/key.properties`
- `.jks` or `.keystore` files
- API secrets or private certificates
- Production user credentials

## Firebase and notifications

Firebase files must match the configured application identifiers:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

Push notification initialization is handled in:

```text
lib/src/services/firebase_messagaging_service.dart
lib/src/services/local_notification_service.dart
```

Test notification permissions and token registration on real devices. Emulators may not support all notification and biometric capabilities.

## Android release signing

The repository includes a template:

```text
android/key.properties.example
```

Copy it to `android/key.properties` and replace all placeholder values with the existing release keystore details:

```bash
cp android/key.properties.example android/key.properties
```

The actual `android/key.properties` file and keystore are ignored by Git. Use the same signing key as previous releases; generating a new key can prevent existing users from receiving app updates.

## Testing checklist

The current repository does not include automated tests. Before release, manually verify:

- Login, biometric login, logout, email verification, and 2FA
- Deposit and payment gateway redirects
- Withdraw account creation and withdrawal submission
- Wallet exchange and investment flows
- KYC file upload and profile updates
- FCM token registration and foreground/background notifications
- Offline mode and API error handling
- Android and iOS release builds on physical devices

## Troubleshooting

If dependencies are stale or corrupted:

```bash
flutter clean
flutter pub get
```

If Android build files are stale:

```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

For API failures, first check the configured base URL, authentication token state, network connectivity, and backend response format.

## License

This is a private HyipRio application. Licensing and redistribution terms are controlled by the project owner.
