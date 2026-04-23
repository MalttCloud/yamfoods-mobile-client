# Security Remediation Report


## Overview

This report summarizes the remediation actions taken in response to the three security findings raised during testing of the application.

## 1. Application Signed With a Debug Certificate

During the development and testing phase, the application was being run using the default debug signing configuration. At that stage, a dedicated production keystore had not yet been created because the application was still under active testing.

This has now been addressed. A dedicated release keystore has been generated and the Android release configuration has been updated to use the release signing setup instead of the debug certificate.

Current status: `Addressed`

## 2. The Application Uses Encryption Mode CBC with PKCS5/PKCS7 padding

The application uses `flutter_secure_storage`, which is a widely adopted and actively maintained secure storage package in the Flutter ecosystem. Our review did not identify any explicit use of CBC mode in the application business logic.

To further strengthen the implementation and remove ambiguity, the secure storage configuration has been updated to explicitly use modern Android cryptographic settings rather than relying on package defaults. The application is now configured to use AES-GCM-based storage settings explicitly.

Current status: `Addressed`

## 3. App Can Be Installed On a Vulnerable Unpatched Android Version

Previously, the application inherited the default minimum Android SDK level, which allowed installation on older Android versions while the app was still being tested across a wider device range.

Based on the security recommendation and current hardening requirements, the minimum supported Android SDK version has now been explicitly increased from `24` to `33`.

This change restricts installation to newer Android versions and improves the overall security posture of the application.

Current status: `Addressed`

## Summary

The following remediation actions have been completed:

- a dedicated release keystore has been created and release signing has been configured
- secure storage has been explicitly configured to use modern cryptographic settings
- the Android minimum SDK level has been raised from `24` to `33`

