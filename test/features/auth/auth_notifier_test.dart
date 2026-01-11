import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:fashion_ecommerce/data/repositories/auth_repository.dart';
import 'package:fashion_ecommerce/data/models/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('AuthNotifier initialization', () {
    test('checks auth status on creation', () {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);

      final notifier = AuthNotifier(mockRepository);

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.user, null);
    });

    test('sets authenticated when user exists', () {
      final user = UserModel(id: '1', fullName: 'Test', email: 'test@test.com');
      when(() => mockRepository.getCurrentUser()).thenReturn(user);
      when(() => mockRepository.isLoggedIn()).thenReturn(true);

      final notifier = AuthNotifier(mockRepository);

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user?.fullName, 'Test');
    });
  });

  group('AuthNotifier.login', () {
    test('successful login updates state', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);

      final user = UserModel(id: '1', fullName: 'John', email: 'john@test.com');
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => user);

      final notifier = AuthNotifier(mockRepository);
      await notifier.login('john@test.com', 'password123', false);

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user?.email, 'john@test.com');
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, null);
    });

    test('failed login sets error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.login(any(), any()),
      ).thenThrow(Exception('Invalid credentials'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.login('test@test.com', 'wrongpass', false);

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.error, contains('Invalid credentials'));
      expect(notifier.state.isLoading, false);
    });

    test('error message removes Exception prefix', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.login(any(), any()),
      ).thenThrow(Exception('Some error'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.login('test@test.com', 'pass', false);

      expect(notifier.state.error, isNot(contains('Exception:')));
    });
  });

  group('AuthNotifier.signUp', () {
    test('successful signup updates state', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);

      final user = UserModel(id: '1', fullName: 'Jane', email: 'jane@test.com');
      when(
        () => mockRepository.signUp(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);

      final notifier = AuthNotifier(mockRepository);
      await notifier.signUp(
        fullName: 'Jane',
        email: 'jane@test.com',
        password: 'password123',
      );

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user?.fullName, 'Jane');
    });

    test('failed signup sets error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.signUp(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Email already exists'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.signUp(
        fullName: 'Test',
        email: 'exists@test.com',
        password: 'password123',
      );

      expect(notifier.state.error, contains('Email already exists'));
      expect(notifier.state.isAuthenticated, false);
    });
  });

  group('AuthNotifier.resetPassword', () {
    test('successful reset completes without error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(() => mockRepository.resetPassword(any())).thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository);
      await notifier.resetPassword('test@test.com');

      expect(notifier.state.error, null);
      expect(notifier.state.isLoading, false);
    });

    test('failed reset sets error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.resetPassword(any()),
      ).thenThrow(Exception('Invalid email'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.resetPassword('invalid');

      expect(notifier.state.error, contains('Invalid email'));
    });
  });

  group('AuthNotifier.verifyResetCode', () {
    test('returns true for valid code', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.verifyResetCode(any()),
      ).thenAnswer((_) async => true);

      final notifier = AuthNotifier(mockRepository);
      final result = await notifier.verifyResetCode('1234');

      expect(result, true);
    });

    test('returns false for invalid code', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.verifyResetCode(any()),
      ).thenAnswer((_) async => false);

      final notifier = AuthNotifier(mockRepository);
      final result = await notifier.verifyResetCode('000');

      expect(result, false);
    });
  });

  group('AuthNotifier.updatePassword', () {
    test('successful update completes without error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(() => mockRepository.updatePassword(any())).thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository);
      await notifier.updatePassword('newPassword123');

      expect(notifier.state.error, null);
      expect(notifier.state.isLoading, false);
    });

    test('failed update sets error', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.updatePassword(any()),
      ).thenThrow(Exception('Password too weak'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.updatePassword('123');

      expect(notifier.state.error, contains('Password too weak'));
    });
  });

  group('AuthNotifier.logout', () {
    test('clears user and auth state', () async {
      final user = UserModel(id: '1', fullName: 'Test', email: 'test@test.com');
      when(() => mockRepository.getCurrentUser()).thenReturn(user);
      when(() => mockRepository.isLoggedIn()).thenReturn(true);
      when(() => mockRepository.logout()).thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository);

      expect(notifier.state.isAuthenticated, true);

      await notifier.logout();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.user, null);
    });
  });

  group('AuthNotifier.clearError', () {
    test('clears error from state', () async {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);
      when(() => mockRepository.isLoggedIn()).thenReturn(false);
      when(
        () => mockRepository.login(any(), any()),
      ).thenThrow(Exception('Error'));

      final notifier = AuthNotifier(mockRepository);
      await notifier.login('test@test.com', 'pass', false);

      expect(notifier.state.error, isNotNull);

      notifier.clearError();

      expect(notifier.state.error, null);
    });
  });
}
