# Riverpod `.future` Best Practices

## The Key Difference

### When to Use `.future`

**Use `.future` when:**
- The provider returns `Future<T>` (async provider)
- You're inside an **async function** and need to **await** the value
- You need the actual `Future<T>` to await, not the `AsyncValue<T>`

### When NOT to Use `.future`

**Don't use `.future` when:**
- The provider returns `T` directly (sync provider)
- You're in a **widget's build method** and need `AsyncValue<T>` for loading/error handling
- The provider is synchronous

---

## Real Examples from Your Codebase

### Example 1: Branch Providers (Uses `.future`) ✅

**Why branch providers use `.future`:**

```dart
// branch_providers.dart

// This provider is ASYNC because it needs SharedPreferences (async initialization)
@riverpod
Future<BranchLocalDataSource> branchLocalDataSource(Ref ref) async {
  // ✅ Use .future because sharedPreferencesProvider returns Future<SharedPreferences>
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return BranchLocalDataSourceImpl(prefs);
}

// This provider is ASYNC because it depends on async branchLocalDataSource
@riverpod
Future<BranchRepository> branchRepository(Ref ref) async {
  final remoteDataSource = ref.watch(branchRemoteDataSourceProvider); // Sync, no .future
  // ✅ Use .future because branchLocalDataSourceProvider returns Future<...>
  final localDataSource = await ref.watch(branchLocalDataSourceProvider.future);
  final logger = ref.watch(loggerProvider); // Sync, no .future
  return BranchRepositoryImpl(remoteDataSource, localDataSource, logger);
}
```

**Why it's async:**
- `BranchLocalDataSource` needs `SharedPreferences` for caching
- `SharedPreferences.getInstance()` is async
- Therefore, the provider chain becomes async

---

### Example 2: Address Providers (No `.future`) ✅

**Why address providers DON'T use `.future`:**

```dart
// address_providers.dart

// All providers are SYNC - no async dependencies
@riverpod
AddressApiService addressApiService(Ref ref) {
  final dio = ref.watch(baseDioClientProvider); // Sync provider
  return AddressApiService(dio);
}

@riverpod
AddressRepository addressRepository(Ref ref) {
  // ✅ No .future needed - addressRemoteDataSourceProvider is sync
  final remoteDataSource = ref.watch(addressRemoteDataSourceProvider);
  return AddressRepositoryImpl(remoteDataSource);
}

@riverpod
GetAddressesUsecase getAddressesUseCase(Ref ref) {
  // ✅ No .future needed - addressRepositoryProvider is sync
  return GetAddressesUsecase(ref.watch(addressRepositoryProvider));
}
```

**Why it's sync:**
- Address feature doesn't use local storage (no SharedPreferences)
- All dependencies are synchronous
- No async initialization needed

---

## The Rule: Provider Type Determines Usage

### Async Provider (Returns `Future<T>`)

```dart
@riverpod
Future<MyRepository> myRepository(Ref ref) async {
  // This is async
  return MyRepository();
}
```

**Inside another async provider:**
```dart
@riverpod
Future<MyUsecase> myUsecase(Ref ref) async {
  // ✅ Use .future to get Future<MyRepository> and await it
  final repository = await ref.watch(myRepositoryProvider.future);
  return MyUsecase(repository);
}
```

**Inside a widget:**
```dart
Widget build(BuildContext context, WidgetRef ref) {
  // ✅ Don't use .future - get AsyncValue for UI state handling
  final repositoryAsync = ref.watch(myRepositoryProvider);
  
  return repositoryAsync.when(
    data: (repo) => Text('Loaded'),
    loading: () => CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
  );
}
```

### Sync Provider (Returns `T`)

```dart
@riverpod
MyService myService(Ref ref) {
  // This is sync
  return MyService();
}
```

**Anywhere:**
```dart
// ✅ Always use without .future - it's not async
final service = ref.watch(myServiceProvider);
```

---

## Decision Tree

```
Is the provider async? (Returns Future<T>)
│
├─ YES → Are you inside an async function?
│   │
│   ├─ YES → Use .future to await
│   │   Example: await ref.watch(provider.future)
│   │
│   └─ NO → Don't use .future (you're in a widget)
│       Example: ref.watch(provider) → returns AsyncValue<T>
│
└─ NO → Never use .future
    Example: ref.watch(provider) → returns T directly
```

---

## Best Practices Summary

| Scenario | Use `.future`? | Example |
|----------|----------------|---------|
| Async provider in async function | ✅ **YES** | `await ref.watch(provider.future)` |
| Async provider in widget build | ❌ **NO** | `ref.watch(provider)` → `AsyncValue<T>` |
| Sync provider anywhere | ❌ **NO** | `ref.watch(provider)` → `T` |
| One-time read in async function | ✅ **YES** | `await ref.read(provider.future)` |

---

## Why This Matters

### 1. **Type Safety**
- `.future` gives you `Future<T>` (can await)
- Without `.future` on async provider gives you `AsyncValue<T>` (for UI state)

### 2. **Performance**
- Riverpod handles caching automatically
- Using `.future` in the right context ensures proper dependency tracking

### 3. **Code Clarity**
- Makes it clear when you're dealing with async vs sync providers
- Follows Riverpod's idiomatic patterns

---

## Common Mistakes

### ❌ Wrong: Using `.future` on sync provider
```dart
@riverpod
MyService myService(Ref ref) => MyService();

// ❌ WRONG - myServiceProvider is sync, no .future property
final service = await ref.watch(myServiceProvider.future);
```

### ❌ Wrong: Not using `.future` when you need to await
```dart
@riverpod
Future<MyRepository> myRepository(Ref ref) async => MyRepository();

@riverpod
Future<MyUsecase> myUsecase(Ref ref) async {
  // ❌ WRONG - This gives AsyncValue, not Future
  final repo = ref.watch(myRepositoryProvider);
  // Can't await AsyncValue!
  return MyUsecase(repo.value!); // Unsafe!
}
```

### ✅ Correct
```dart
@riverpod
Future<MyUsecase> myUsecase(Ref ref) async {
  // ✅ CORRECT - Use .future to get Future and await
  final repo = await ref.watch(myRepositoryProvider.future);
  return MyUsecase(repo);
}
```

---

## Your Codebase Pattern

### Branch Feature (Has Local Storage)
- Uses `SharedPreferences` → Async initialization
- Providers are async → Use `.future` when awaiting

### Address Feature (No Local Storage)
- No async dependencies
- Providers are sync → No `.future` needed

**Both patterns are correct!** The difference comes from the dependencies, not a mistake.

