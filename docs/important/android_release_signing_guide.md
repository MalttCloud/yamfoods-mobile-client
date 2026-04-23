# Android Release Signing Guide

This document explains the production-safe Android signing workflow for this Flutter project.

It is written as a future reference so the release signing setup can be recreated cleanly without guessing.

## Goal

Use a proper Android release key for production builds instead of the debug key.

This gives us:

- a real production signing identity
- release builds suitable for Play Store upload
- stable signing for future app updates
- SHA-1 and SHA-256 fingerprints for Firebase and other integrations

## Recommended Practice

For a new app that is not yet published, the recommended setup is:

1. Generate an `upload` keystore in modern `PKCS12` format.
2. Store the keystore file in `android/app/`.
3. Store passwords and alias in `android/key.properties`.
4. Ignore the keystore and `key.properties` in git.
5. Configure `android/app/build.gradle.kts` to sign release builds with that keystore.
6. Build a release `.aab` for Play Store uploads.

For Play Store distribution, the recommended production model is:

- use Google Play App Signing
- keep this local keystore as the upload key

## Final File Locations Used In This Project

- Keystore file: `android/app/upload-keystore.p12`
- Secret properties file: `android/key.properties`
- Gradle signing config: `android/app/build.gradle.kts`

## Step 1: Generate A New Upload Key

Run this from the project root:

```powershell
keytool -genkeypair -v -keystore "android/app/upload-keystore.p12" -storetype PKCS12 -keyalg RSA -keysize 4096 -validity 10000 -alias upload
```

Recommended values:

- alias: `upload`
- store type: `PKCS12`
- key algorithm: `RSA`
- key size: `4096`
- validity: `10000`

During the prompts:

- use a strong password
- store the password in a password manager
- it is fine to use the same password for the keystore and the key alias if you want a simpler setup

## Step 2: Create `android/key.properties`

Create this file:

`android/key.properties`

Template:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../app/upload-keystore.p12
```

Notes:

- `storeFile` is relative to the `android/` folder because `key.properties` is loaded from there
- if you use the same password for both, then `storePassword` and `keyPassword` will have the same value
- never commit this file to git

## Step 3: Ignore Secret Files In Git

The root `.gitignore` should include these entries:

```gitignore
android/key.properties
android/app/*.jks
android/app/*.p12
android/app/*.keystore
upload-keystore.jks
```

If only the final PKCS12 keystore is used, the most important files to ignore are:

- `android/key.properties`
- `android/app/upload-keystore.p12`

## Step 4: Configure Gradle Release Signing

The file `android/app/build.gradle.kts` should:

1. load `key.properties`
2. create a `release` signing config
3. use that signing config in `buildTypes.release`

This project is already configured that way.

The important idea is:

- release builds must use the `release` signing config
- release builds must not use the debug key

## Step 5: Build A Signed Release

For Play Store uploads, build an Android App Bundle:

```powershell
flutter build appbundle --release
```

Output:

`build/app/outputs/bundle/release/app-release.aab`

If you want a signed APK for testing:

```powershell
flutter build apk --release
```

Output:

`build/app/outputs/flutter-apk/app-release.apk`

## Step 6: Verify The Setup Worked

### Check that the release build succeeds

Run:

```powershell
flutter build appbundle --release
```

If the build succeeds, signing is configured correctly.

### Check that secret files are not tracked

Run:

```powershell
git status --short
```

These files should not appear:

- `android/key.properties`
- `android/app/upload-keystore.p12`
- any old local keystore copy such as `upload-keystore.jks`

### Optional: verify the APK signature

If you built an APK, you can verify it with:

```powershell
apksigner verify --print-certs "build/app/outputs/flutter-apk/app-release.apk"
```

This should print certificate details for the release signing certificate.

## Get SHA-1 And SHA-256 For Firebase

To print the certificate fingerprints from the release keystore, run:

```powershell
keytool -list -v -keystore "android/app/upload-keystore.p12" -storetype PKCS12 -alias upload
```

Look for these lines in the output:

- `SHA1:`
- `SHA256:`

These are the values commonly needed for:

- Firebase
- Google Sign-In
- OAuth-related Android app registration
- some API provider dashboards

## Debug Fingerprints

If debug fingerprints are also needed for local development, run:

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Use debug fingerprints only for debug/local development integrations.

Use the release keystore fingerprints for production release setup.

## Firebase Guidance

Before the app is published:

- add the release keystore `SHA-1`
- add the release keystore `SHA-256`
- optionally add the debug `SHA-1` and `SHA-256` for local testing

After the app is published with Google Play App Signing:

- check Play Console for the Play signing certificate fingerprints
- some integrations may need Play signing fingerprints in addition to the upload key fingerprints

## Security Rules

- never commit `android/key.properties`
- never commit the keystore file
- never share keystore passwords in chat, email, or source control
- back up the keystore file in a secure location
- back up the alias name and passwords in a secure password manager

## Recovery Checklist

Store these values somewhere secure:

- keystore file name
- keystore file location
- alias name
- store password
- key password
- SHA-1 fingerprint
- SHA-256 fingerprint

Without these, future release signing becomes painful.

## One-Time Setup Summary

Use this when setting up a new machine or recreating the process:

1. Place the keystore at `android/app/upload-keystore.p12`.
2. Create `android/key.properties` with the correct alias, passwords, and `storeFile`.
3. Confirm `.gitignore` excludes the signing files.
4. Confirm `android/app/build.gradle.kts` uses the `release` signing config.
5. Run `flutter build appbundle --release`.
6. Run `keytool -list -v -keystore "android/app/upload-keystore.p12" -storetype PKCS12 -alias upload` to retrieve the release fingerprints.

## Notes For This Project

- Current Android release signing is configured in `android/app/build.gradle.kts`
- The current keystore path used by this project is `android/app/upload-keystore.p12`
- The current alias used by this project is `upload`
- The current minimum Android SDK configured in this project is `33`


Build.gradle.kts  before update 

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.yamfoods_customer_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // added for flutter local notification
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.yamfoods_customer_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 33
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


Build.gradle.kts  after update

import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.yamfoods_customer_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // added for flutter local notification
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.yamfoods_customer_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 33
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                val storeFilePath = keystoreProperties.getProperty("storeFile")
                val resolvedStoreFile = rootProject.file(storeFilePath).takeIf {
                    it.exists()
                } ?: file(storeFilePath)

                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = resolvedStoreFile
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
