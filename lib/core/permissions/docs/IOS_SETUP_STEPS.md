# iOS Setup Steps - Run When You Have macOS Access

# Full setup sequence (run these when you get macOS access):

cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run -d ios

aleke kefelek ketach temeliket

This document contains the steps you need to complete when you get access to a macOS machine to finish the iOS configuration for permission_handler.

## ✅ Already Completed (No Action Needed)

The following have already been configured and are ready:

- ✅ **Podfile created** at `ios/Podfile` with permission_handler macros
- ✅ **Info.plist updated** with all required permission descriptions
- ✅ **Android configuration** completed (gradle.properties, AndroidManifest.xml)

## 📋 Steps to Run on macOS

### Step 1: Navigate to iOS Directory

```bash
cd ios
```

### Step 2: Install CocoaPods (if not already installed)

Check if CocoaPods is installed:

```bash
pod --version
```

If not installed, install it:

```bash
sudo gem install cocoapods
```

### Step 3: Install iOS Dependencies

Run pod install to install all iOS dependencies including permission_handler:

```bash
pod install
```

**Expected Output:**

- You should see "Pod installation complete!"
- A `Pods/` directory will be created
- A `Podfile.lock` file will be created

### Step 4: Verify Installation

Check that the Pods directory exists:

```bash
ls -la Pods/
```

### Step 5: Return to Project Root

```bash
cd ..
```

### Step 6: Clean and Rebuild (Optional but Recommended)

```bash
flutter clean
flutter pub get
```

### Step 7: Test iOS Build

Try building for iOS to verify everything works:

```bash
flutter build ios --no-codesign
```

Or run on iOS simulator:

```bash
flutter run -d ios
```

## ⚠️ Important Notes

1. **CocoaPods is Required**: iOS development requires CocoaPods to be installed. It's a Ruby gem that manages iOS dependencies.

2. **Xcode is Required**: You'll also need Xcode installed from the Mac App Store to build iOS apps.

3. **Permission Handler Configuration**: The Podfile already has the permission_handler macros configured for:

   - Location permissions (`PERMISSION_LOCATION=1`)
   - Photo library permissions (`PERMISSION_PHOTOS=1`)
   - Camera permissions (`PERMISSION_CAMERA=1`)

4. **Info.plist Already Configured**: All required permission descriptions are already in `ios/Runner/Info.plist`:
   - `NSLocationWhenInUseUsageDescription`
   - `NSLocationAlwaysAndWhenInUseUsageDescription`
   - `NSPhotoLibraryUsageDescription`
   - `NSCameraUsageDescription`

## 🔍 Troubleshooting

### If `pod install` fails:

1. Make sure you're in the `ios/` directory
2. Check that CocoaPods is installed: `pod --version`
3. Try updating CocoaPods: `sudo gem install cocoapods`
4. Try cleaning: `pod deintegrate && pod install`

### If build fails:

1. Clean Flutter: `flutter clean`
2. Clean CocoaPods: `cd ios && pod deintegrate && pod install && cd ..`
3. Delete `ios/Pods/` and `ios/Podfile.lock` and run `pod install` again

## 📝 Quick Reference Commands

```bash
# Full setup sequence (run these when you get macOS access):
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run -d ios
```

## ✅ Checklist

When you get macOS access, verify:

- [ ] CocoaPods is installed (`pod --version` works)
- [ ] `pod install` completes successfully
- [ ] `ios/Pods/` directory exists
- [ ] `ios/Podfile.lock` file exists
- [ ] Flutter can build for iOS (`flutter build ios --no-codesign`)
- [ ] App runs on iOS simulator
- [ ] Permission requests work correctly on iOS device/simulator

---

**Note**: All iOS configuration files (Podfile, Info.plist) are already set up. You only need to run `pod install` when you get macOS access to install the dependencies.
