# Simple Auth State Usage (Bloc-like)

Simple, clean API for checking authentication status - no boilerplate!

## Quick Start

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_user_state.dart';

// Simple boolean check - just like Bloc!
final isAuthenticated = ref.watch(isAuthenticatedProvider);
if (isAuthenticated) {
  // User is authenticated
} else {
  // User is not authenticated
}
```

---

## Example 1: Simple Navigation Check

```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      // Navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteName.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // User is authenticated - show profile
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Content')),
    );
  }
}
```

---

## Example 2: Conditional UI

```dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (!isAuthenticated)
            TextButton(
              onPressed: () => context.push(RouteName.login),
              child: const Text('Login'),
            )
          else
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.push(RouteName.profile),
            ),
        ],
      ),
      body: isAuthenticated
          ? const AuthenticatedContent()
          : const WelcomeScreen(),
    );
  }
}
```

---

## Example 3: Get Current User

```dart
class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Text('Not logged in');
    }

    return Column(
      children: [
        Text('Welcome, ${user.name}!'),
        Text('Email: ${user.email}'),
      ],
    );
  }
}
```

---

## Example 4: Button Action Check

```dart
void _onCheckoutPressed(BuildContext context, WidgetRef ref) {
  final isAuthenticated = ref.read(isAuthenticatedProvider);

  if (!isAuthenticated) {
    // Show login dialog or navigate
    context.push(RouteName.login);
    return;
  }

  // Proceed with checkout
  // ...
}
```

---

## Example 5: GoRouter Redirect (Route Guard)

```dart
final appRouter = GoRouter(
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final isAuthenticated = container.read(isAuthenticatedProvider);

    // Protect routes that require authentication
    final protectedRoutes = [RouteName.home, RouteName.profile];

    if (protectedRoutes.contains(state.matchedLocation) && !isAuthenticated) {
      return RouteName.login;
    }

    return null; // No redirect
  },
  routes: [
    // ... your routes
  ],
);
```

---

## Example 6: Listen to Auth Changes

```dart
class AuthListenerWidget extends ConsumerWidget {
  const AuthListenerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth changes
    ref.listen<bool>(isAuthenticatedProvider, (previous, next) {
      if (!previous && next) {
        // User just logged in
        context.go(RouteName.home);
      } else if (previous && !next) {
        // User just logged out
        context.go(RouteName.login);
      }
    });

    return const Scaffold(
      body: Center(child: Text('Listening to auth changes...')),
    );
  }
}
```

---

## Summary

### Two Simple Providers:

1. **`isAuthenticatedProvider`** → `bool`
   - `true` = authenticated
   - `false` = not authenticated (or loading/error)

2. **`currentUserProvider`** → `User?`
   - `User` = authenticated user
   - `null` = not authenticated (or loading/error)

### Usage Pattern:

```dart
// Simple boolean check
final isAuthenticated = ref.watch(isAuthenticatedProvider);
if (isAuthenticated) { /* ... */ }

// Get user
final user = ref.watch(currentUserProvider);
if (user != null) { /* ... */ }

// One-time read in callbacks
final isAuth = ref.read(isAuthenticatedProvider);
```

**That's it! No AsyncValue.when(), no boilerplate - just simple, clean checks!** 🎉

