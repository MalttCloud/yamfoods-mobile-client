# Provider Lifecycle Analysis & Best Practices

## Executive Summary

**Status: ⚠️ CRITICAL DEPENDENCIES MISSING `keepAlive`**

Several core dependencies used across multiple features are missing `keepAlive: true`, which can cause:

- Unnecessary recreation of expensive resources
- Performance degradation
- Potential memory leaks from recreating Dio instances
- Inconsistent state across features

---

## Dependencies Analysis

### ✅ Already Using `keepAlive: true` (Correct)

| Provider                    | Usage Count                | Status       | Reason                       |
| --------------------------- | -------------------------- | ------------ | ---------------------------- |
| `envConfigProvider`         | All features               | ✅ KeepAlive | Core config, used everywhere |
| `loggerProvider`            | All features               | ✅ KeepAlive | Logging service, singleton   |
| `secureStorageProvider`     | Auth, Onboarding           | ✅ KeepAlive | Secure storage singleton     |
| `sharedPreferencesProvider` | Auth, Branch, Onboarding   | ✅ KeepAlive | Local storage singleton      |
| `authUserStateProvider`     | All authenticated features | ✅ KeepAlive | Auth state, app-wide         |

### ❌ Missing `keepAlive: true` (CRITICAL)

| Provider                 | Usage Count     | Current Status  | Impact                          | Priority     |
| ------------------------ | --------------- | --------------- | ------------------------------- | ------------ |
| `baseDioClientProvider`  | **8+ features** | ❌ Auto-dispose | **HIGH** - Recreated frequently | **CRITICAL** |
| `dioClientProvider`      | **3+ features** | ❌ Auto-dispose | **HIGH** - Recreated frequently | **CRITICAL** |
| `tokenValidatorProvider` | 1 (but core)    | ❌ Auto-dispose | **MEDIUM** - Core service       | **HIGH**     |

---

## Usage Breakdown

### `baseDioClientProvider` - Used by 8+ Features

**Features using it:**

1. ✅ Auth (unprotected routes - login, register)
2. ✅ Branch (unprotected - getAllBranches)
3. ✅ Category (unprotected)
4. ✅ Subcategory (unprotected)
5. ✅ Product (unprotected)
6. ✅ Achievement (unprotected)
7. ✅ Promocode (unprotected)
8. ✅ Promo Banner (unprotected)
9. ⚠️ Address (should use dioClient - all endpoints are protected)

**Why it needs `keepAlive`:**

- Expensive to create (sets up interceptors, base configuration)
- Used across 8+ features
- Recreating it causes unnecessary overhead
- Interceptors are recreated each time

### `dioClientProvider` - Used by 3+ Features

**Features using it:**

1. ✅ Review (protected routes)
2. ✅ Cart (protected routes)
3. ✅ Order (protected routes)
4. ⚠️ Address (should use this instead of baseDioClient)

**Why it needs `keepAlive`:**

- Very expensive to create (clones baseDio, adds auth interceptor)
- Watches multiple auth providers (async dependencies)
- Used by critical authenticated features
- Recreating causes auth interceptor to be recreated

### `tokenValidatorProvider` - Core Service

**Used by:**

- `dioClientProvider` (via AuthInterceptor)

**Why it needs `keepAlive`:**

- Core authentication service
- Stateless singleton (no reason to dispose)
- Used by auth interceptor which is used app-wide

---

## Recommended Changes

### 1. Add `keepAlive: true` to Dio Clients

```dart
// lib/core/network/di/dio_client.dart

/// Base Dio client provider (without auth interceptor)
///
/// CRITICAL: Uses keepAlive because this is used by 8+ features.
/// Recreating it causes unnecessary overhead and interceptor recreation.
@Riverpod(keepAlive: true)
Dio baseDioClient(Ref ref) {
  // ... existing code
}

/// Dio client provider with all interceptors configured (including auth)
///
/// CRITICAL: Uses keepAlive because this is used by 3+ authenticated features.
/// Recreating it causes expensive auth interceptor recreation and watches.
@Riverpod(keepAlive: true)
Future<Dio> dioClient(Ref ref) async {
  // ... existing code
}
```

### 2. Add `keepAlive: true` to TokenValidator

```dart
// lib/core/services/token_validator.dart

/// Token validator provider
///
/// Uses keepAlive because this is a core authentication service
/// used app-wide by the auth interceptor.
@Riverpod(keepAlive: true)
TokenValidator tokenValidator(Ref ref) {
  final logger = ref.watch(loggerProvider);
  return TokenValidator(logger: logger);
}
```

### 3. Fix Address Feature (Bug)

**Issue:** Address uses `baseDioClientProvider` but all endpoints are protected.

**Fix:** Change to use `dioClientProvider`:

```dart
// lib/features/address/presentation/providers/address_providers.dart

@riverpod
Future<AddressApiService> addressApiService(Ref ref) async {
  // ✅ Change from baseDioClientProvider to dioClientProvider
  final dio = await ref.watch(dioClientProvider.future);
  return AddressApiService(dio);
}
```

---

## Best Practices Summary

### When to Use `keepAlive: true`

✅ **DO use `keepAlive: true` for:**

1. **Core Infrastructure Services**

   - Dio clients (network layer)
   - Loggers
   - Storage instances (SharedPreferences, SecureStorage)
   - Configuration providers

2. **App-Wide State**

   - Authentication state
   - User preferences
   - Global settings

3. **Expensive to Create**

   - Services with heavy initialization
   - Services that set up interceptors
   - Services that watch multiple providers

4. **Used by Many Features**
   - If 3+ features use it, consider `keepAlive`
   - If it's a core dependency, use `keepAlive`

### ❌ DON'T use `keepAlive: true` for:

1. **Feature-Specific Providers**

   - Use cases (unless truly app-wide)
   - Feature-specific repositories
   - UI state providers

2. **Temporary/Ephemeral State**

   - Form state
   - Loading states
   - One-time operations

3. **Data Providers**
   - Lists of items (products, orders, etc.)
   - Cached API responses (Riverpod handles this automatically)

---

## Performance Impact

### Without `keepAlive` (Current State)

```
User navigates: Home → Product → Cart → Order
├─ baseDioClientProvider: Created 3 times ❌
├─ dioClientProvider: Created 2 times ❌
├─ tokenValidatorProvider: Created 2 times ❌
└─ Interceptors: Recreated multiple times ❌
```

**Issues:**

- Unnecessary object creation
- Interceptor setup overhead
- Potential memory churn
- Slower navigation

### With `keepAlive` (Recommended)

```
User navigates: Home → Product → Cart → Order
├─ baseDioClientProvider: Created once ✅ (reused)
├─ dioClientProvider: Created once ✅ (reused)
├─ tokenValidatorProvider: Created once ✅ (reused)
└─ Interceptors: Created once ✅ (reused)
```

**Benefits:**

- Single instance per app lifecycle
- Better performance
- Consistent state
- Lower memory overhead

---

## Implementation Priority

1. **CRITICAL** - Add `keepAlive` to Dio clients (immediate impact)
2. **HIGH** - Add `keepAlive` to TokenValidator (core service)
3. **MEDIUM** - Fix Address feature to use correct Dio client (bug fix)

---

## Testing Checklist

After implementing changes:

- [ ] Verify Dio clients are created only once
- [ ] Test navigation between features (should be faster)
- [ ] Verify auth interceptor works correctly
- [ ] Check memory usage (should be lower)
- [ ] Test address CRUD operations (should work with auth)

---

## References

- [Riverpod keepAlive Documentation](https://riverpod.dev/docs/concepts/provider_lifecycle)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/best_practices)
