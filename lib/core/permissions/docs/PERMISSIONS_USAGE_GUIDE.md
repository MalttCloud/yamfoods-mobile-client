# Permission Handler Usage Guide

This document explains how to properly use `permission_handler` package in this project after the configuration setup.

## ✅ Configuration Status

### iOS ✅

- **Podfile**: Created with permission macros for location, camera, and photos
- **Info.plist**: Added all required permission descriptions
- **Next Step**: Run `cd ios && pod install` to install dependencies

### Android ✅

- **gradle.properties**: AndroidX and Jetifier enabled
- **AndroidManifest.xml**: Location and media permissions declared
- **compileSdkVersion**: Using Flutter's default (should be 35 with Flutter 3.38.3)

## 📱 Permission Usage in Code

### Location Permissions

**For foreground location (most common use case):**

```dart
import 'package:permission_handler/permission_handler.dart';

// Check status
var status = await Permission.locationWhenInUse.status;
if (status.isDenied) {
  // Request permission
  status = await Permission.locationWhenInUse.request();
}

if (status.isGranted) {
  // Use location
}
```

**Important for Android 10+ (API 29+):**
If you need background location, you MUST request foreground location first:

```dart
// Step 1: Request foreground location first
var foregroundStatus = await Permission.locationWhenInUse.request();

if (foregroundStatus.isGranted) {
  // Step 2: Only then request background location
  var backgroundStatus = await Permission.locationAlways.request();
  // User will see system dialog to "Allow All The Time"
}
```

⚠️ **DO NOT** request both `locationWhenInUse` and `locationAlways` at the same time - Android will ignore it!

### Photo/Gallery Permissions (Android 13+)

**❌ WRONG - Don't use this on Android 13+:**

```dart
// This will always return denied on Android 13+ (API 33+)
await Permission.storage.request(); // DON'T USE
```

**✅ CORRECT - Use Permission.photos instead:**

```dart
// For Android 13+ and iOS
Permission permission;
if (Platform.isAndroid) {
  // Check Android version
  if (await Permission.photos.isGranted ||
      await Permission.storage.isGranted) {
    // Already granted
  } else {
    // Request photos permission for Android 13+
    permission = Permission.photos;
  }
} else {
  permission = Permission.photos; // iOS
}

var status = await permission.request();
if (status.isGranted) {
  // Access photos/gallery
}
```

**Or use a helper function:**

```dart
Future<bool> requestPhotoPermission() async {
  if (Platform.isAndroid) {
    // For Android 13+, use photos permission
    // Permission.photos handles both new and old Android versions
    final status = await Permission.photos.request();
    return status.isGranted;
  } else {
    // iOS
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
```

### Camera Permission

```dart
var status = await Permission.camera.status;
if (status.isDenied) {
  status = await Permission.camera.request();
}

if (status.isGranted) {
  // Use camera
} else if (status.isPermanentlyDenied) {
  // User denied permanently - open app settings
  await openAppSettings();
}
```

## 🎯 Best Practices

1. **Request permissions at the right time**: Don't request all permissions at app start. Request them when the user actually needs the feature.

2. **Handle all permission states**:

   ```dart
   var status = await Permission.locationWhenInUse.request();

   if (status.isGranted) {
     // Permission granted
   } else if (status.isDenied) {
     // First time denial - user can grant later
   } else if (status.isPermanentlyDenied) {
     // User denied permanently - show dialog and open settings
     await openAppSettings();
   } else if (status.isRestricted) {
     // OS restricts access (parental controls, etc.)
   }
   ```

3. **Show rationale on Android**:

   ```dart
   if (await Permission.location.shouldShowRequestRationale) {
     // Show explanation dialog before requesting
     // This is Android-specific
   }
   ```

4. **Use the callback style for better readability**:
   ```dart
   await Permission.camera
     .onDeniedCallback(() {
       // Handle denied
     })
     .onGrantedCallback(() {
       // Handle granted
     })
     .onPermanentlyDeniedCallback(() {
       // Handle permanently denied - open settings
       openAppSettings();
     })
     .request();
   ```

## 📋 Permission Reference

### Available Permissions for This Project

| Permission                     | Android API                  | iOS | Use Case                        |
| ------------------------------ | ---------------------------- | --- | ------------------------------- |
| `Permission.locationWhenInUse` | ✅                           | ✅  | Show nearby branches, maps      |
| `Permission.locationAlways`    | ✅ (requires step-by-step)   | ✅  | Background location tracking    |
| `Permission.photos`            | ✅ (Android 13+)             | ✅  | Profile picture upload          |
| `Permission.camera`            | ✅                           | ✅  | Take profile picture            |
| `Permission.storage`           | ❌ Deprecated on Android 13+ | N/A | Use `Permission.photos` instead |

## 🚨 Common Mistakes to Avoid

1. **Using `Permission.storage` on Android 13+** → Use `Permission.photos` instead
2. **Requesting `locationAlways` without requesting `locationWhenInUse` first** → Always request foreground location first
3. **Requesting multiple location permissions simultaneously** → Android will ignore the request
4. **Missing Info.plist descriptions on iOS** → App will crash (already fixed ✅)
5. **Not handling `isPermanentlyDenied`** → User can never grant permission without going to settings

## 📚 Additional Resources

- [permission_handler Package](https://pub.dev/packages/permission_handler)
- [Android Location Permissions Guide](https://developer.android.com/training/location/permissions)
- [iOS Privacy Usage Descriptions](https://developer.apple.com/documentation/bundleresources/information_property_list)
