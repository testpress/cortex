## 1. Network Layer & UserAgent Refactor
 
- [x] 1.1 Create `dioProvider` in `packages/core/lib/network/network_provider.dart` using Riverpod.
- [x] 1.2 Merge `UserAgentHelper.generate()` logic into `UserAgentInterceptor` and delete the helper file.
- [x] 1.3 Move default interceptor initialization (UserAgentInterceptor) into the `dioProvider`.
 
## 2. Smart Auth Interceptor
 
- [x] 2.1 Refactor `AuthInterceptor` in `packages/core/lib/network/auth_interceptor.dart` to include a `publicPaths` exclusion list.
- [x] 2.2 Implement `onError` in `AuthInterceptor` to catch 401 status codes.
- [x] 2.3 Ensure Interceptor's `getToken` callback remains agnostic of the repository/state-management.
- [x] 2.4 Handle global logout by injecting a `onUnauthorized` callback into the Interceptor.
 
## 3. Dependency Injection Refactor
 
- [x] 3.1 Update `AuthApiService` constructor in `packages/core/lib/data/auth/auth_api_service.dart` to require `Dio dio` and remove internal initialization.
- [x] 3.2 Update `HttpDataSource` constructor in `packages/core/lib/data/sources/http_data_source.dart` to require `Dio dio` and remove internal initialization.
- [x] 3.3 Update `authApiServiceProvider` in `packages/core/lib/data/auth/auth_provider.dart` to inject `ref.watch(dioProvider)`.
- [x] 3.4 Create or update the provider for `HttpDataSource` to inject `ref.watch(dioProvider)`.
 
## 4. Validation
 
- [x] 4.1 Verify that the application still boots correctly and restores auth state.
- [x] 4.2 Verify that login requests do NOT have an Authorization header attached by the interceptor.
- [x] 4.3 Verify that general data requests (e.g., profile) still include the Authorization header.
- [x] 4.4 Simulate a 401 error and verify it triggers a global logout and redirect to the login screen.
