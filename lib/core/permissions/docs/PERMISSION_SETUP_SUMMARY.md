# Permission Handler Setup Summary

## ✅ Completed Configuration (January 2026)

All necessary configurations for `permission_handler: ^12.0.1` have been completed for both iOS and Android platforms.

### iOS Configuration ✅

1. **Created `ios/Podfile`**

   - Added permission_handler macros for:
     - `PERMISSION_LOCATION=1` (Location access for maps/branches)
     - `PERMISSION_PHOTOS=1` (Gallery access for profile pictures)
     - `PERMISSION_CAMERA=1` (Camera access for taking photos)
   - **Action Required**: Run `cd ios && pod install` to install dependencies

2. **Updated `ios/Runner/Info.plist`**

   - Added `NSLocationWhenInUseUsageDescription` - "We need your location to show nearby branches and improve your delivery experience."
   - Added `NSLocationAlwaysAndWhenInUseUsageDescription` - "We need your location to provide accurate delivery tracking and show nearby branches."
   - Added `NSPhotoLibraryUsageDescription` - "We need access to your photos to let you upload a profile picture."
   - Added `NSCameraUsageDescription` - "We need camera access to let you take a profile picture."

   **⚠️ Critical**: Without these entries, iOS will crash when checking/requesting permissions!

### Android Configuration ✅

1. **Updated `android/gradle.properties`**

   - Added `android.enableJetifier=true` (for legacy dependency compatibility)
   - Already had `android.useAndroidX=true`

2. **Updated `android/app/src/main/AndroidManifest.xml`**

   - Added `android:maxSdkVersion="32"` to `READ_EXTERNAL_STORAGE` permission
     - This ensures it's only used on Android 12 and below
     - Android 13+ will use `READ_MEDIA_IMAGES` instead
   - Already had `READ_MEDIA_IMAGES` permission for Android 13+
   - Added helpful comments about using `Permission.photos` instead of `Permission.storage`

3. **Build Configuration**
   - Using Flutter's default `compileSdkVersion` (should be 35 with Flutter 3.38.3)
   - Using Kotlin DSL (`build.gradle.kts`) - modern approach ✅

## 📋 Next Steps

### ⚠️ For macOS Users (iOS Setup Required):

**See `IOS_SETUP_STEPS.md` for detailed instructions** - This document contains step-by-step commands you need to run when you have macOS access to complete iOS configuration.

**Quick Summary:**

```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### ✅ For Windows/Android Development:

You're all set! The iOS configuration files are ready. When you get macOS access, follow `IOS_SETUP_STEPS.md`.

### When Writing Permission Code:

1. **For Location**:

   - Use `Permission.locationWhenInUse` for foreground location
   - If you need background location, request `locationWhenInUse` FIRST, then `locationAlways`

2. **For Photos/Gallery** (Android 13+):

   - **DO NOT** use `Permission.storage` - it will always return denied on Android 13+
   - **USE** `Permission.photos` instead
   - See `lib/core/permissions/PERMISSIONS_USAGE_GUIDE.md` for code examples

3. **For Camera**:
   - Use `Permission.camera` - works on both platforms

## 📚 Documentation Created

- **`lib/core/permissions/PERMISSIONS_USAGE_GUIDE.md`** - Comprehensive guide on how to use permissions in your code with examples and best practices

## ⚠️ Important Notes from Documentation

### What Matters (2026):

- ✅ iOS Info.plist entries (CRITICAL - already done)
- ✅ iOS Podfile macros (CRITICAL - already done)
- ✅ Android 13+ storage permissions (use `Permission.photos`, not `Permission.storage`)
- ✅ Location permission sequence on Android 10+ (request foreground first, then background)

### What Doesn't Matter (Outdated Warnings):

- ❌ "Upgrade pre-1.12 Android projects" - Not relevant for Flutter 3.38.3
- ❌ `compileSdkVersion` warnings - Flutter handles this automatically with `flutter.compileSdkVersion`
- ❌ Manual AndroidX migration - Already configured

## 🧪 Testing Checklist

Before releasing, test:

- [ ] Request location permission on iOS - should show dialog with your custom message
- [ ] Request location permission on Android - should work correctly
- [ ] Request photo permission on Android 13+ device - should use new permission model
- [ ] Request photo permission on Android 12 or below - should work with legacy permission
- [ ] Request camera permission on both platforms
- [ ] Test permanently denied scenario - should open app settings
- [ ] Test background location (if needed) - request foreground first, then background

## 🎯 Summary

All critical configurations are complete! The app is ready to use `permission_handler` package. The main things to remember when coding:

1. Use `Permission.photos` not `Permission.storage` for Android 13+
2. Request `locationWhenInUse` before `locationAlways` on Android
3. Handle all permission states (granted, denied, permanentlyDenied, restricted)

For detailed code examples, see: `lib/core/permissions/PERMISSIONS_USAGE_GUIDE.md`
