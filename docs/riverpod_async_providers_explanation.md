# Riverpod Async Providers: `.future` vs Without `.future`

## Understanding the Difference

### When a Provider Returns `Future<T>`

When you define a provider that returns `Future<T>`:

```dart
@riverpod
Future<AuthRepository> authRepository(Ref ref) async {
  // ... async code
  return AuthRepositoryImpl(...);
}
```

Riverpod automatically wraps this in an `AsyncValue<T>`. This means:

1. **Without `.future`**: `ref.watch(authRepositoryProvider)` returns `AsyncValue<AuthRepository>`
2. **With `.future`**: `ref.watch(authRepositoryProvider.future)` returns `Future<AuthRepository>`

## When to Use `.future`

### ✅ **Use `.future` Inside Async Provider Functions**

When you're inside another async provider and need to await the value:

```dart
@riverpod
Future<LoginUsecase> loginUsecase(Ref ref) async {
  // ✅ CORRECT: Use .future to get Future<AuthRepository> and await it
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUsecase(repository);
}
```

**Why?**

- You're in an async function
- You need to await the repository before creating the usecase
- `.future` gives you the `Future<T>` directly, which you can await

### ❌ **Without `.future` Inside Async Functions**

If you tried without `.future`:

```dart
@riverpod
Future<LoginUsecase> loginUsecase(Ref ref) async {
  // ❌ WRONG: This gives you AsyncValue<AuthRepository>, not Future
  final asyncValue = ref.watch(authRepositoryProvider);

  // You'd have to do this (more verbose):
  if (asyncValue.isLoading) {
    // Handle loading...
  }
  if (asyncValue.hasError) {
    // Handle error...
  }
  final repository = asyncValue.value!; // Unsafe!
  return LoginUsecase(repository);
}
```

**Problems:**

- More verbose
- You have to manually handle loading/error states
- Less type-safe (using `!` operator)
- Not the idiomatic way inside async providers

## When to Use WITHOUT `.future`

### ✅ **In Widgets (UI Layer)**

In widgets, you typically want `AsyncValue` to handle loading/error states:

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ CORRECT: Get AsyncValue to handle loading/error states
    final loginUsecaseAsync = ref.watch(loginUsecaseProvider);

    return loginUsecaseAsync.when(
      data: (usecase) => LoginForm(usecase: usecase),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

**Why?**

- Widgets need to show loading/error states
- `AsyncValue.when()` is perfect for this
- You don't need to await anything in the build method

## Summary Table

| Context                         | Use `.future`?        | Why                                              |
| ------------------------------- | --------------------- | ------------------------------------------------ |
| Inside async provider function  | ✅ **YES**            | Need `Future<T>` to await                        |
| Inside widget build method      | ❌ **NO**             | Need `AsyncValue<T>` for loading/error handling  |
| Inside notifier methods         | ✅ **YES** (if async) | Need to await the value                          |
| One-time read in async function | ✅ **YES**            | `ref.read(provider.future)` gives you the Future |

## Best Practice Rules

1. **Inside async provider functions**: Always use `.future` when you need to await
2. **Inside widgets**: Use without `.future` to get `AsyncValue` for UI state handling
3. **Inside async notifier methods**: Use `.future` when you need to await
4. **One-time reads**: Use `ref.read(provider.future)` in async contexts

## Real Example from Our Code

```dart
// ✅ CORRECT: Inside async provider
@riverpod
Future<LoginUsecase> loginUsecase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUsecase(repository);
}

// ✅ CORRECT: In widget
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUsecaseAsync = ref.watch(loginUsecaseProvider);
    return loginUsecaseAsync.when(
      data: (usecase) => /* use the usecase */,
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(e),
    );
  }
}
```

## Why This is Best Practice

1. **Type Safety**: `.future` gives you the exact type you need (`Future<T>`)
2. **Cleaner Code**: No need to manually unwrap `AsyncValue` in async contexts
3. **Performance**: Riverpod handles caching and error propagation automatically
4. **Idiomatic**: This is the recommended pattern in Riverpod documentation

## References

- [Riverpod FutureProvider Documentation](https://riverpod.dev/docs/providers/future_provider)
- [Riverpod AsyncValue Documentation](https://riverpod.dev/docs/concepts/reading#handling-loading-and-error-states)
