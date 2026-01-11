import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:fashion_ecommerce/data/models/user_model.dart';

void main() {
  group('AuthState', () {
    test('initial state has no user', () {
      final state = AuthState();

      expect(state.user, null);
      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.isAuthenticated, false);
    });

    test('copyWith updates user', () {
      final state = AuthState();
      final user = UserModel(id: '1', fullName: 'John', email: 'john@test.com');
      final updated = state.copyWith(user: user);

      expect(updated.user?.fullName, 'John');
      expect(state.user, null);
    });

    test('copyWith updates isLoading', () {
      final state = AuthState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
      expect(state.isLoading, false);
    });

    test('copyWith updates error', () {
      final state = AuthState();
      final updated = state.copyWith(error: 'Invalid credentials');

      expect(updated.error, 'Invalid credentials');
      expect(state.error, null);
    });

    test('copyWith updates isAuthenticated', () {
      final state = AuthState();
      final updated = state.copyWith(isAuthenticated: true);

      expect(updated.isAuthenticated, true);
      expect(state.isAuthenticated, false);
    });

    test('copyWith preserves values when not specified', () {
      final user = UserModel(id: '1', fullName: 'Jane', email: 'jane@test.com');
      final state = AuthState(
        user: user,
        isLoading: true,
        isAuthenticated: true,
      );
      final updated = state.copyWith(error: 'Error');

      expect(updated.user?.fullName, 'Jane');
      expect(updated.isLoading, true);
      expect(updated.isAuthenticated, true);
    });

    test('copyWith clears error', () {
      final state = AuthState(error: 'Some error');
      final updated = state.copyWith(error: null);

      expect(updated.error, null);
    });

    test('state with authenticated user', () {
      final user = UserModel(id: '1', fullName: 'Test', email: 'test@test.com');
      final state = AuthState(user: user, isAuthenticated: true);

      expect(state.isAuthenticated, true);
      expect(state.user?.email, 'test@test.com');
    });
  });

  group('AuthState transitions', () {
    test('loading to success transition', () {
      final loadingState = AuthState(isLoading: true);

      expect(loadingState.isLoading, true);
      expect(loadingState.isAuthenticated, false);

      final user = UserModel(id: '1', fullName: 'User', email: 'user@test.com');
      final successState = loadingState.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );

      expect(successState.isLoading, false);
      expect(successState.isAuthenticated, true);
      expect(successState.user?.fullName, 'User');
    });

    test('loading to error transition', () {
      final loadingState = AuthState(isLoading: true);
      final errorState = loadingState.copyWith(
        isLoading: false,
        error: 'Network error',
      );

      expect(errorState.isLoading, false);
      expect(errorState.error, 'Network error');
      expect(errorState.isAuthenticated, false);
    });

    test('authenticated to logged out transition', () {
      final user = UserModel(id: '1', fullName: 'User', email: 'user@test.com');
      final authState = AuthState(user: user, isAuthenticated: true);

      final loggedOutState = AuthState();

      expect(loggedOutState.user, null);
      expect(loggedOutState.isAuthenticated, false);
    });
  });
}
