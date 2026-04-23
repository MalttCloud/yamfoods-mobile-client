# Dependency Injection Analysis Report

## Executive Summary

**Status: ⚠️ CIRCULAR DEPENDENCY DETECTED**

A circular dependency exists in the auth/Dio client setup that contradicts the documented solution.

---

## Dependency Graph Analysis

### 1. Core Providers (No Dependencies) ✅

```
envConfigProvider → No dependencies
loggerProvider → No dependencies
secureStorageProvider → No dependencies
sharedPreferencesProvider → No dependencies
```

### 2. Token Validator ✅

```
tokenValidatorProvider
  └─→ loggerProvider (core, safe)
```

### 3. Dio Client Providers ⚠️

```
baseDioClientProvider
  └─→ envConfigProvider (core, safe)
  └─→ loggerProvider (core, safe)
  ✅ No circular dependency

dioClientProvider
  └─→ baseDioClientProvider (safe)
  └─→ loggerProvider (core, safe)
  └─→ authRepositoryProvider (⚠️ creates cycle)
  └─→ authLocalDataSourceProvider (⚠️ creates cycle)
  └─→ tokenValidatorProvider (safe)
```

### 4. Auth Providers ⚠️

```
authApiServiceProvider
  └─→ dioClientProvider ⚠️ CIRCULAR DEPENDENCY!

authRemoteDataSourceProvider
  └─→ authApiServiceProvider

authLocalDataSourceProvider
  └─→ secureStorageProvider (core, safe)
  └─→ sharedPreferencesProvider (core, safe)

authRepositoryProvider
  └─→ authRemoteDataSourceProvider
  └─→ authLocalDataSourceProvider
```

---

## Circular Dependency Chain

**The Problematic Cycle:**

```
1. dioClientProvider
   └─→ authRepositoryProvider (line 73 in dio_client.dart)
       └─→ authRemoteDataSourceProvider
           └─→ authApiServiceProvider
               └─→ dioClientProvider ⚠️ CIRCULAR!
```

**Evidence:**

- `lib/core/network/di/dio_client.dart:73` - `dioClientProvider` watches `authRepositoryProvider`
- `lib/features/auth/presentation/providers/auth_providers.dart:31` - `authApiServiceProvider` uses `dioClientProvider`

---

## Root Cause

The documentation (`docs/circular_dependency_note.md`) states that the circular dependency was resolved by having `authApiService` use `baseDioClientProvider`. However, the actual implementation still uses `dioClientProvider`:

**Current Code (WRONG):**

```dart
// lib/features/auth/presentation/providers/auth_providers.dart:30-32
@riverpod
Future<AuthApiService> authApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future); // ⚠️ WRONG!
  return AuthApiService(dio);
}
```

**Expected Code (CORRECT):**

```dart
@riverpod
Future<AuthApiService> authApiService(Ref ref) async {
  final dio = ref.watch(baseDioClientProvider); // ✅ Should use baseDioClient
  return AuthApiService(dio);
}
```

---

## Impact

1. **Runtime Issues**: May cause provider initialization failures or infinite loops
2. **Build Issues**: Riverpod may detect this and throw errors
3. **Maintainability**: Code doesn't match documented architecture

---

## Recommended Fix

Change `authApiServiceProvider` to use `baseDioClientProvider` instead of `dioClientProvider`:

```dart
@riverpod
Future<AuthApiService> authApiService(Ref ref) async {
  final dio = ref.watch(baseDioClientProvider); // Use base, not full client
  return AuthApiService(dio);
}
```

**Why this works:**

- `baseDioClientProvider` has no auth dependencies
- `authApiService` can be created without waiting for auth providers
- `dioClientProvider` (with auth interceptor) is used for all other API calls
- The cycle is broken

---

## Other Dependencies (All Safe) ✅

### Onboarding Providers

```
onboardingLocalDataSourceProvider → secureStorageProvider (safe)
onboardingRepositoryProvider → onboardingLocalDataSourceProvider (safe)
isFirstTimeUsecaseProvider → onboardingRepositoryProvider (safe)
```

### Auth UseCases

All use cases depend on `authRepositoryProvider` which is safe (no cycles).

---

## Summary

| Category         | Status   | Issues                  |
| ---------------- | -------- | ----------------------- |
| Core Providers   | ✅ Safe  | None                    |
| Token Validator  | ✅ Safe  | None                    |
| Dio Base Client  | ✅ Safe  | None                    |
| Dio Full Client  | ✅ Fixed | Was creating cycle      |
| Auth API Service | ✅ Fixed | Now uses baseDioClient  |
| Auth Repository  | ✅ Fixed | No longer part of cycle |
| Other Providers  | ✅ Safe  | None                    |

**Total Issues Found: 1 Circular Dependency - FIXED ✅**

---

## Fix Applied

**Changed:**

- `authApiServiceProvider` now uses `baseDioClientProvider` instead of `dioClientProvider`
- Removed `async/Future` from `authApiServiceProvider` and `authRemoteDataSourceProvider` (they're now sync)
- Regenerated providers with `build_runner`

**Result:**

- Circular dependency broken
- All providers compile successfully
- Architecture matches documented design
