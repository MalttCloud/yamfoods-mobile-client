# Application Security Statement

**Product:** Noodo Bakers (Customer Mobile Application)  
**Platform:** Flutter (Android / iOS)  
**Document type:** Security & privacy posture summary for regulatory and assurance review  
**Audience:** Information security assessors (INSA )

---

## 1. Purpose and scope

This document describes how the customer application protects user data and session integrity in line with common mobile security expectations. It covers:

- Classification of data and corresponding storage controls  
- Authentication tokens and encryption on device  
- Transport security and network-layer safeguards  
- Platform configuration (Android/iOS) relevant to integrity and confidentiality  
- Logging and operational practices that reduce exposure of sensitive data  

It is intended to support assurance that the application is **designed and implemented** with appropriate safeguards. Ongoing security also depends on **server-side controls**, **operational key management**, and **timely updates**—which are referenced where relevant but not fully specified here.

---

## 2. Executive summary

The application follows a **defence-in-depth** approach:

| Area | Approach |
|------|------------|
| **Session credentials** | Stored only in **platform-backed secure storage** with strong cryptographic settings on Android |
| **Non-sensitive preferences** | Stored in **SharedPreferences** (standard app preferences), not used for access tokens |
| **Transport** | API communication uses **HTTPS**; the Android manifest does not enable cleartext (HTTP) traffic |
| **Android baseline** | **Minimum SDK 33** (Android 13), supporting a modern security baseline on supported devices |
| **Release integrity** | **Production releases are signed with the organization’s release keystore**, not the default debug certificate |
| **Diagnostics** | Verbose HTTP logging and sensitive header output are limited to **debug builds**; production builds avoid this noise and reduce data exposure risk |

---

## 3. Security principles

The implementation is guided by the following principles:

1. **Separation of sensitivity** — Cryptographic secrets (access and refresh tokens) are isolated from general UI/cache data.  
2. **Least privilege on the wire** — Authenticated calls attach bearer tokens only where required; unauthenticated routes are excluded from automatic token injection.  
3. **Platform alignment** — Where available, the app uses OS-provided secure storage (Keychain / Keystore-backed abstractions via `flutter_secure_storage`) rather than ad-hoc encryption in application code alone.  
4. **No cleartext-by-default on Android** — The application does not declare broad cleartext HTTP permission in the main manifest.  
5. **Minimal sensitive logging in production** — Request/response logging is gated so it does not run in release builds.

---

## 4. Data classification and on-device storage

### 4.1 High-sensitivity data (tokens)

**What:** OAuth-style **access tokens** and **refresh tokens** used to authenticate API requests.

**Where stored:** `flutter_secure_storage` (`FlutterSecureStorage`), accessed through a single application-wide provider.

**Android cryptographic profile:** The application configures **explicit algorithm choices** for Android:

- **Key encryption:** RSA with **ECB OAEP** using **SHA-256** and MGF1 padding  
- **Value encryption:** **AES-GCM** (no padding)  
- **Migration:** `migrateOnAlgorithmChange` is enabled so algorithm upgrades can be applied safely when the library/OS supports it  

This aligns with common expectations for **strong, modern** primitives on Android rather than legacy or weak defaults.

**iOS:** Secure storage is mapped to the platform Keychain through the same plugin; behaviour follows iOS Keychain access patterns as implemented by `flutter_secure_storage`.

**Operational note:** Protection of tokens also depends on **device OS security** (lock screen, device compromise). The app cannot fully mitigate a fully compromised device; controls are at **application and OS storage** level.

### 4.2 Lower-sensitivity / non-credential data (SharedPreferences)

**What:** Cached **user profile fields** used for offline display and app state (e.g. name, email, phone, identifiers required for the profile screen)—**not** authentication secrets.

**Where stored:** `SharedPreferences`, documented in code as intended for **non-sensitive** data relative to tokens.

**Rationale:** SharedPreferences is appropriate for **non-credential** application preferences and profile cache where the primary session secrets remain in secure storage. This design:

- Keeps **bearer tokens and refresh tokens** out of plaintext preference files  
- Limits SharedPreferences to data that is **not sufficient** to impersonate the user without the server-issued tokens held in secure storage  

Assessors may still consider profile fields as **personal data**; the statement here is about **credential isolation** and **proportionate storage**, not an assertion that SharedPreferences is encrypted at rest in the same way as the Keychain/Keystore-backed token store.

### 4.3 Other secure storage usage

Certain flags (e.g. first-launch / onboarding completion) are stored via the same secure storage abstraction where the product team chose to keep even low-sensitivity state consistent with hardened storage patterns.

---

## 5. Authentication and session handling (network layer)

### 5.1 Token lifecycle

- Tokens are **read from secure storage** when attaching `Authorization: Bearer …` to protected requests.  
- The stack includes **proactive and reactive refresh** (expiry checks and handling of authentication failures) through a dedicated **auth interceptor**, reducing the window where invalid tokens are used.  
- Unauthenticated users do not have protected requests sent with empty credentials (requests are cancelled rather than generating unnecessary failed calls).

### 5.2 Transport security

- Base URLs for production are configured to use **HTTPS** endpoints.  
- The Android **main** `AndroidManifest.xml` does **not** set `android:usesCleartextTraffic="true"`, avoiding a blanket allowance for unencrypted HTTP.  
- iOS **App Transport Security** is not weakened in the checked `Info.plist` with arbitrary HTTP exceptions for production traffic.

---

## 6. Android platform configuration

| Control | Implementation |
|--------|------------------|
| **Minimum SDK** | **33** — restricts the app to Android 13 and above for new installs/updates per this configuration, supporting a more current security baseline |
| **Compile / Java** | Modern toolchain (e.g. Java 17 compatibility as defined in Gradle) |
| **Cleartext** | Not explicitly enabled for the release application manifest |

---

## 7. Application signing and release integrity

**Production releases** are built with the **release** signing configuration that references the organization’s **release keystore** and credentials supplied via `key.properties` (not committed to source control).

This ensures:

- Binaries distributed to users are signed with a **long-lived production key** under organizational control  
- The default **debug** keystore used only in development is **not** used for store-ready release artefacts when the release signing configuration is correctly applied in the build pipeline  

**Organizational responsibility:** CI/CD and release engineers must ensure every store submission is produced with `key.properties` (or equivalent secrets) so release signing is always active.

---

## 8. Logging, diagnostics, and privacy of technical data

### 8.1 HTTP logging interceptor

A `LoggingInterceptor` is attached to the HTTP client for **developer diagnostics**. It:

- Runs **only when `kDebugMode` is true** — in standard Flutter release builds, request/response body logging **does not execute**  
- **Redacts** sensitive header names (e.g. `Authorization`, API keys, cookies) when logging in debug  

This reduces the risk of **tokens or secrets** appearing in device logs or attached debug consoles in production builds.

### 8.2 General logging

A structured `Logger` is used application-wide; production builds should continue to follow the policy of **no secrets in logs** (tokens, OTPs, full payment payloads).

---

## 9. Third-party services

The application integrates services such as **Firebase** (e.g. messaging, authentication helpers) and **payment SDKs**. These components have their own security models and data processing terms. The organization’s privacy policy and vendor assessments should cover:

- What data leaves the device to those processors  
- Their certifications and subprocessors  

This document focuses on **first-party app implementation** choices above.

---

## 10. What this document does not claim

For transparency with assessors:

- **Root/jailbreak detection** is not described here as a primary control; if required by policy, it would be a separate product decision and implementation.  
- **Certificate pinning** is not asserted in this statement unless added explicitly in a future revision.  
- **Server-side** security (API hardening, rate limits, fraud, WAF) is **complementary** and documented separately.  

---

## 11. Conclusion

The Noodo Bakers customer application implements a **clear separation** between **high-sensitivity session material** (stored in **secure storage with strong Android encryption parameters**) and **non-token application data** (stored in **SharedPreferences** where appropriate). **HTTPS** is used for API communication, **cleartext HTTP is not enabled** in the main Android manifest, **minimum SDK** is set to a modern level, and **release builds are intended to be signed with the organization’s release certificate**. Diagnostic HTTP logging is **disabled in release builds**, with **header redaction** in debug.

Together, these measures describe a **professional, user-focused security posture** suitable for review by bodies such as INSA, subject to complementary organisational and backend controls.

---

## 12. Document maintenance

| Version | Date | Notes |
|---------|------|--------|
| 1.0 | *(22 March 2026)* |Submitted to INSA|

**Prepared by:** *(Security / Engineering — Rejeb Dendir)*  
**Review cadence:** Update after major authentication, storage, or network architecture changes.
