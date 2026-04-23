## API service architecture

### Goals

- Clear, scalable structure for all HTTP APIs.
- Strong type-safety with Retrofit.
- Central place for routes while keeping feature isolation.

### High-level design

- **One shared `Dio` client** in `core` (configured with interceptors, base URL, timeouts).
- **Feature-specific Retrofit services** (auth, branch, order, etc.).
- **Central routes file** named `api_routes.dart` (to avoid confusion with `app_router.dart` for navigation).

### File structure

- `lib/core/network/`
  - `dio_client.dart` (to be created)
  - `api_routes.dart` (to be created)
  - `interceptors/`
    - `logging_interceptor.dart`
  - `models/`
    - `api_response.dart`
    - `error_model.dart`
    - `meta_model.dart`
- `lib/features/<feature>/data/datasources/`
  - `*_api_service.dart` (Retrofit interfaces per feature)
  - `*_remote_datasource.dart` (uses the API service + `ErrorHandler`)

### `api_routes.dart` (central route constants)

- Purpose: single source of truth for backend paths.
- Example:

```dart
class ApiRoutes {
  // Auth
  static const String authBase = 'auth';
  static const String login = '$authBase/login';
  static const String register = '$authBase/register';
  static const String logout = '$authBase/logout';

  // Branch
  static const String branches = 'branches';
  static const String branchById = '$branches/{id}';

  // Orders
  static const String orders = 'orders';
  static const String createOrder = orders;
}
```

### Feature-specific API services

- Each feature gets its own Retrofit interface.
- They **use** `ApiRoutes` constants instead of hard-coded strings.

Example for auth:

```dart
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST(ApiRoutes.login)
  Future<ApiResponse<User>> login(@Body() LoginRequest request);

  @POST(ApiRoutes.register)
  Future<ApiResponse<User>> register(@Body() RegisterRequest request);
}
```

Example for branches:

```dart
@RestApi()
abstract class BranchApiService {
  factory BranchApiService(Dio dio) = _BranchApiService;

  @GET(ApiRoutes.branches)
  Future<ApiResponse<List<Branch>>> getBranches();

  @GET(ApiRoutes.branchById)
  Future<ApiResponse<Branch>> getBranch(@Path('id') int id);
}
```

### Why not a single generic `post(route)` / `get(route)`?

- **Loses type-safety**: route typos are not caught at compile time.
- **Bypasses Retrofit’s strengths** (declarative, type-safe endpoints).
- **Harder to discover and refactor**: routes are just strings passed around.
- **Less self-documenting**: reading the interface doesn’t tell you what endpoints exist.

Using feature-specific services with `api_routes.dart`:

- Keeps routes centralized.
- Keeps APIs explicit and type-safe.
- Matches common clean-architecture + Retrofit practice in production apps.

### How datasources use services + error handling

- Datasource calls the feature API service.
- Handles `ApiResponse.success` / `ApiResponse.error`.
- Uses `ErrorHandler.handleException` in `catch` blocks.

Example pattern (pseudocode):

```dart
try {
  final response = await _authApiService.login(request);

  return response.when(
    success: (success, data, meta) => Right(data),
    error: (success, error, meta) =>
        Left(ErrorHandler.mapBackendError(error, statusCode)),
  );
} catch (e) {
  return Left(ErrorHandler.handleException(e));
}
```


