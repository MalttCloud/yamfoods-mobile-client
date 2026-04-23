# App size reduction guide (Play Store & App Store)

This document summarizes what this project does and what you can do to keep download size small, without changing app behavior.

---

## What’s already done in this project

- **Android R8 code shrinking** – `android/app/build.gradle.kts` enables `isMinifyEnabled` and `isShrinkResources` for the release build. R8 removes unused Java/Kotlin code and resources (often 15–25% smaller).
- **ProGuard rules** – `android/app/proguard-rules.pro` keeps Flutter and plugin classes so the app still runs after shrinking.
- **Resource locales** – `resourceConfigurations += setOf("en")` so only English resources are packaged. If you add more languages, add them here (e.g. `"en", "am"`).

---

## Build commands (use these for store uploads)

### Android (Play Store) – use App Bundle

Always upload an **App Bundle** (`.aab`), not a universal APK. Play Store then generates smaller, device-specific APKs for users.

```bash
# Recommended: obfuscate Dart and strip debug symbols (smaller + safer)
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

- Save the `build/app/outputs/symbols` folder; you need it for symbolicated crash reports (e.g. Firebase Crashlytics).
- Output: `build/app/outputs/bundle/release/app-release.aab` → upload to Play Console.

If you hit build or runtime issues with obfuscation, you can temporarily build without it:

```bash
flutter build appbundle --release
```

### iOS (App Store)

```bash
# Recommended: obfuscate and strip debug info
flutter build ios --release --obfuscate --split-debug-info=build/ios/symbols
```

Then open Xcode, archive, and upload to App Store Connect. App Thinning is applied by Apple automatically.

---

## Optional: further size reductions

### 1. Assets (images, Lottie, fonts)

- **Images** – Prefer WebP and appropriate resolutions (e.g. 2x for retina). Compress with [Squoosh](https://squoosh.app/) or similar. Remove unused images.
- **Lottie/JSON** – Keep only needed Lottie files; large JSON animations add to size.
- **Fonts** – You ship Cera Pro (Bold, Medium) and Griffin. Only list fonts you actually use in the UI.
- **Videos** – If you have a splash video (e.g. `.mp4`), consider replacing with a Lottie or static image to cut size.

### 2. Dependencies

- Unused packages are already removed (e.g. `pinput`, `action_slider`). Periodically run `flutter pub outdated` and remove anything you don’t use.
- `font_awesome_flutter` ships many icons; you only need the ones you use (Flutter tree-shakes icon fonts by default for Material/Cupertino; Font Awesome may still add weight).

### 3. Deferred loading (advanced)

For large features (e.g. map, checkout), you can load Dart code on demand:

```dart
// Load a library only when needed
import 'package:yamfoods_customer_app/features/map/map_screen.dart' deferred as map;

// Later: await map.loadLibrary(); then use map.MapScreen()
```

This reduces initial download and can shrink the main bundle. Use only where the feature is not needed at startup.

### 4. Measuring size

- **Android** – After uploading the `.aab`, use Play Console → Your app → Release → App size to see download/install size by device.
- **Local AAB** – Use Android’s `bundletool` or “Analyze APK” in Android Studio on an APK built from the bundle.
- **iOS** – After uploading the build, use App Store Connect → TestFlight or the build details to see size.

---

## Quick checklist before each store release

- [ ] Build Android with: `flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols`
- [ ] Build iOS with: `flutter build ios --release --obfuscate --split-debug-info=build/ios/symbols`
- [ ] Keep the `symbols` folders for crash symbolication
- [ ] Add more locales to `resourceConfigurations` only if you support them
- [ ] Remove or compress any new large assets (images/videos) before release

---

## References

- [Flutter: Reduce app size](https://docs.flutter.dev/perf/app-size)
- [Flutter: Obfuscate Dart code](https://docs.flutter.dev/deployment/obfuscate)
- [Android: Enable R8 / app optimization](https://developer.android.com/topic/performance/app-optimization/enable-app-optimization)
