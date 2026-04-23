# Presentation Layer Plan - Riverpod Generator 3.0.3

## Overview

This document outlines the plan for implementing the presentation layer using **Riverpod Generator 3.0.3** following industry best practices and Clean Architecture principles.

## Architecture Principles

### 1. **Separation of Concerns**

- **Providers**: Dependency injection (repositories, usecases, services)
- **Notifiers**: State management for UI logic
- **States**: Immutable state classes using Freezed
- **Screens/Widgets**: Pure UI components

### 2. **Provider Types Strategy**

#### `@riverpod` - For Dependency Injection

- Repositories
- UseCases
- Services
- External dependencies

#### `@notifier` - For Stateful UI Logic

- Form state management
- UI state (loading, error, success)
- Local state that needs methods

#### `@asyncNotifier` - For Async Operations

- API calls
- Data fetching
- Operations that return `Future<Either<Failure, T>>`

## Folder Structure

```
lib/features/auth/presentation/
├── providers/
│   ├── auth_providers.dart          # Dependency injection providers
│   ├── login_notifier.dart          # Login state management
│   ├── register_notifier.dart       # Register state management
│   ├── logout_notifier.dart         # Logout state management
│   └── ... (other notifiers)
├── states/
│   ├── auth_state.dart              # Auth-related states
│   └── ... (other states)
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── ... (other screens)
└── widgets/
    ├── login_form.dart
    └── ... (reusable widgets)
```

## Implementation Plan

### Phase 1: Dependency Injection Providers

**File: `lib/features/auth/presentation/providers/auth_providers.dart`**

This file will contain all dependency injection providers for the auth feature.

**Key Points:**

- Use `@riverpod` for all DI providers
- Providers are auto-generated (no manual implementation)
- Follow naming convention: `{name}Provider`

### Phase 2: State Classes

**File: `lib/features/auth/presentation/states/auth_state.dart`**

Create Freezed state classes for each feature's state.

**Key Points:**

- Use `sealed class` with Freezed
- States should be immutable
- Include loading, success, error, and initial states

### Phase 3: Notifiers

Create notifiers for each feature that needs state management.

**Key Points:**

- Use `@asyncNotifier` for operations that call usecases
- Use `@notifier` for local UI state
- Handle `Either<Failure, T>` from usecases
- Convert failures to user-friendly messages

### Phase 4: Screens & Widgets

Create screens and widgets that consume the providers.

**Key Points:**

- Use `ref.watch()` for reactive data
- Use `ref.read()` for one-time reads or method calls
- Handle loading, error, and success states
- Use `ConsumerWidget` or `HookConsumerWidget`

## Best Practices

### 1. **Error Handling**

- Always handle `Either<Failure, T>` from usecases
- Use `FailureMapper` to convert failures to user messages
- Show user-friendly error messages in UI

### 2. **State Management**

- Keep states minimal and focused
- Use separate notifiers for different features
- Don't mix UI state with business logic

### 3. **Provider Naming**

- Providers: `{name}Provider` (e.g., `authRepositoryProvider`)
- Notifiers: `{feature}Notifier` (e.g., `loginNotifier`)
- Generated: `{name}Provider` (e.g., `loginNotifierProvider`)

### 4. **Testing**

- Test notifiers independently
- Mock providers in tests
- Test state transitions

### 5. **Performance**

- Use `ref.watch()` only when needed
- Use `ref.read()` for one-time operations
- Consider `autoDispose` for temporary providers

## Code Examples

See the following files for detailed code examples:

- `docs/presentation_layer_examples.md` (to be created)
