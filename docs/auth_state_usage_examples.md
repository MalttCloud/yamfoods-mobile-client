# Auth State Usage Examples

This document shows how to use `authUserStateProvider` in different scenarios for navigation and UI decisions.

## Provider Overview

```dart
// Single Source of Truth for Authentication
final authUserStateProvider = ref.watch(authUserStateProvider);
// Returns: AsyncValue<User?>
// - AsyncValue.data(User) = authenticated
// - AsyncValue.data(null) = not authenticated
// - AsyncValue.loading() = checking auth state
// - AsyncValue.error() = error checking auth state
```

---

## Example 1: Simple Navigation Check in Widget

**Use Case:** Navigate to login if user is not authenticated

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authUserStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not authenticated - navigate to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(RouteName.login);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Authenticated - show profile
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ${user.name}!'),
                Text('Email: ${user.email}'),
                // ... rest of profile UI
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => context.go(RouteName.login),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Example 2: Conditional UI Rendering

**Use Case:** Show different UI based on auth status

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authUserStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Show login button if not authenticated
          authState.when(
            data: (user) => user == null
                ? TextButton(
                    onPressed: () => context.push(RouteName.login),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  )
                : IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => context.push(RouteName.profile),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => TextButton(
              onPressed: () => context.push(RouteName.login),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            // Not authenticated - show welcome message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome to YamFoods!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.push(RouteName.login),
                    child: const Text('Login to Continue'),
                  ),
                ],
              ),
            );
          }

          // Authenticated - show home content
          return ListView(
            children: [
              Text('Hello, ${user.name}!'),
              // ... rest of home content
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

---

## Example 3: Quick Auth Check (Using `.select`)

**Use Case:** Only rebuild when auth status changes, not when user data changes

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class ProtectedScreen extends ConsumerWidget {
  const ProtectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when isAuthenticated changes, not when user data changes
    final isAuthenticated = ref.watch(
      authUserStateProvider.select((asyncValue) => asyncValue.valueOrNull != null),
    );

    if (!isAuthenticated) {
      // Navigate to login immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteName.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // User is authenticated - show protected content
    return Scaffold(
      appBar: AppBar(title: const Text('Protected Content')),
      body: const Center(child: Text('This is protected content')),
    );
  }
}
```

---

## Example 4: Getting Current User Data

**Use Case:** Access current user information anywhere

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_user_state.dart';

class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authUserStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Text('Not logged in');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone ?? 'Not set'}'),
            Text('Phone Verified: ${user.phoneVerified ? 'Yes' : 'No'}'),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

---

## Example 5: GoRouter Redirect (Route Guard)

**Use Case:** Protect routes that require authentication

```dart
// In your app_router.dart or route configuration

import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../features/auth/presentation/providers/auth_user_state.dart';
import 'route_names.dart';

/// Redirect to login if user is not authenticated
String? authGuard(WidgetRef ref) {
  final authState = ref.read(authUserStateProvider);
  
  // If still loading, don't redirect yet
  if (authState.isLoading) {
    return null; // Stay on current route while loading
  }

  // If error or not authenticated, redirect to login
  if (authState.hasError || authState.valueOrNull == null) {
    return RouteName.login;
  }

  // User is authenticated - allow access
  return null;
}

final appRouter = GoRouter(
  initialLocation: RouteName.splash,
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    
    // Protect routes that require authentication
    final protectedRoutes = [
      RouteName.home,
      RouteName.profile,
      RouteName.orders,
      // ... other protected routes
    ];

    if (protectedRoutes.contains(state.matchedLocation)) {
      return authGuard(container.read);
    }

    return null; // No redirect needed
  },
  routes: [
    // ... your routes
  ],
);
```

---

## Example 6: Using in StatefulWidget with Navigation

**Use Case:** Check auth state and navigate in initState or button press

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth state after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final authState = ref.read(authUserStateProvider);
    
    if (authState.valueOrNull == null) {
      // Not authenticated - navigate to login
      context.go(RouteName.login);
    }
  }

  void _onCheckoutPressed() {
    final authState = ref.read(authUserStateProvider);
    
    if (authState.valueOrNull == null) {
      // Show dialog or navigate to login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to proceed with checkout.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(RouteName.login);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return;
    }

    // User is authenticated - proceed with checkout
    // ... checkout logic
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authUserStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: Column(
            children: [
              // Checkout form
              ElevatedButton(
                onPressed: _onCheckoutPressed,
                child: const Text('Complete Checkout'),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => context.go(RouteName.login),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Example 7: Simple Boolean Check

**Use Case:** Quick check without handling loading/error states

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class QuickCheckExample extends ConsumerWidget {
  const QuickCheckExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Quick check - returns true if user exists, false otherwise
    final isAuthenticated = ref.watch(
      authUserStateProvider.select(
        (asyncValue) => asyncValue.valueOrNull != null,
      ),
    );

    if (!isAuthenticated) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.push(RouteName.login),
            child: const Text('Login Required'),
          ),
        ),
      );
    }

    // User is authenticated
    return Scaffold(
      body: const Center(child: Text('Welcome!')),
    );
  }
}
```

---

## Example 8: Listen to Auth Changes

**Use Case:** React to auth state changes (e.g., logout)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../providers/auth_user_state.dart';

class AuthListenerExample extends ConsumerWidget {
  const AuthListenerExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes
    ref.listen<AsyncValue<User?>>(authUserStateProvider, (previous, next) {
      // Previous state had user, but now it's null (user logged out)
      if (previous?.valueOrNull != null && next.valueOrNull == null) {
        // Navigate to login
        context.go(RouteName.login);
      }

      // User just logged in
      if (previous?.valueOrNull == null && next.valueOrNull != null) {
        // Navigate to home
        context.go(RouteName.home);
      }
    });

    return Scaffold(
      body: const Center(child: Text('Listening to auth changes...')),
    );
  }
}
```

---

## Summary

### Key Patterns:

1. **For UI Rendering**: Use `ref.watch(authUserStateProvider)` with `.when()` to handle loading/error states
2. **For Quick Checks**: Use `.select()` to only rebuild when auth status changes
3. **For Navigation**: Use `ref.read()` in callbacks or `ref.listen()` to react to changes
4. **For Route Guards**: Use `ref.read()` in GoRouter redirect function

### Best Practices:

- ✅ Always handle `AsyncValue` states (loading, error, data)
- ✅ Use `.select()` when you only need auth status, not user data
- ✅ Use `ref.listen()` to react to auth changes (login/logout)
- ✅ Use `ref.read()` for one-time checks in callbacks
- ✅ Navigate in `addPostFrameCallback` to avoid build-time navigation errors

