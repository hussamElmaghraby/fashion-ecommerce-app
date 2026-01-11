import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/data/repositories/auth_repository.dart';
import 'package:fashion_ecommerce/data/services/storage_service.dart';
import 'package:fashion_ecommerce/data/models/user_model.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late AuthRepository repository;
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    repository = AuthRepository(mockStorage);
  });

  setUpAll(() {
    registerFallbackValue(UserModel(id: '', fullName: '', email: ''));
  });

  group('login', () {
    test('throws exception for empty email', () async {
      expect(() => repository.login('', 'password123'), throwsException);
    });

    test('throws exception for empty password', () async {
      expect(() => repository.login('test@test.com', ''), throwsException);
    });

    test('throws exception for invalid email format', () async {
      expect(
        () => repository.login('invalid-email', 'password123'),
        throwsException,
      );
    });

    test('throws exception for short password', () async {
      expect(() => repository.login('test@test.com', '12345'), throwsException);
    });

    test('returns user on successful login', () async {
      when(() => mockStorage.saveUser(any())).thenAnswer((_) async {});
      when(() => mockStorage.saveAuthToken(any())).thenAnswer((_) async {});

      final user = await repository.login('test@example.com', 'password123');

      expect(user.email, 'test@example.com');
      expect(user.fullName, 'John Doe');
      verify(() => mockStorage.saveUser(any())).called(1);
      verify(() => mockStorage.saveAuthToken(any())).called(1);
    });
  });

  group('signUp', () {
    test('throws exception for empty fullName', () async {
      expect(
        () => repository.signUp(
          fullName: '',
          email: 'test@test.com',
          password: 'password123',
        ),
        throwsException,
      );
    });

    test('throws exception for empty email', () async {
      expect(
        () => repository.signUp(
          fullName: 'John',
          email: '',
          password: 'password123',
        ),
        throwsException,
      );
    });

    test('throws exception for invalid email format', () async {
      expect(
        () => repository.signUp(
          fullName: 'John',
          email: 'invalid',
          password: 'password123',
        ),
        throwsException,
      );
    });

    test('throws exception for short password', () async {
      expect(
        () => repository.signUp(
          fullName: 'John',
          email: 'test@test.com',
          password: '12345',
        ),
        throwsException,
      );
    });

    test('returns user on successful signup', () async {
      when(() => mockStorage.saveUser(any())).thenAnswer((_) async {});
      when(() => mockStorage.saveAuthToken(any())).thenAnswer((_) async {});

      final user = await repository.signUp(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        password: 'password123',
      );

      expect(user.fullName, 'Jane Doe');
      expect(user.email, 'jane@example.com');
    });
  });

  group('resetPassword', () {
    test('throws exception for empty email', () async {
      expect(() => repository.resetPassword(''), throwsException);
    });

    test('throws exception for invalid email', () async {
      expect(() => repository.resetPassword('invalidemail'), throwsException);
    });

    test('completes successfully for valid email', () async {
      await expectLater(repository.resetPassword('valid@email.com'), completes);
    });
  });

  group('verifyResetCode', () {
    test('returns true for 4-digit code', () async {
      final result = await repository.verifyResetCode('1234');
      expect(result, true);
    });

    test('returns false for short code', () async {
      final result = await repository.verifyResetCode('123');
      expect(result, false);
    });

    test('returns false for long code', () async {
      final result = await repository.verifyResetCode('12345');
      expect(result, false);
    });
  });

  group('updatePassword', () {
    test('throws exception for short password', () async {
      expect(() => repository.updatePassword('12345'), throwsException);
    });

    test('completes successfully for valid password', () async {
      await expectLater(
        repository.updatePassword('validPassword123'),
        completes,
      );
    });
  });

  group('logout', () {
    test('clears auth token and user', () async {
      when(() => mockStorage.deleteAuthToken()).thenAnswer((_) async {});
      when(() => mockStorage.deleteUser()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockStorage.deleteAuthToken()).called(1);
      verify(() => mockStorage.deleteUser()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('returns null when no user saved', () {
      when(() => mockStorage.getUser()).thenReturn(null);

      final user = repository.getCurrentUser();

      expect(user, null);
    });

    test('returns user when saved', () {
      final savedUser = UserModel(
        id: 'user_1',
        fullName: 'Test User',
        email: 'test@test.com',
      );

      when(() => mockStorage.getUser()).thenReturn(savedUser);

      final user = repository.getCurrentUser();

      expect(user?.fullName, 'Test User');
      expect(user?.email, 'test@test.com');
    });
  });

  group('isLoggedIn', () {
    test('returns false when no token', () {
      when(() => mockStorage.getAuthToken()).thenReturn(null);

      expect(repository.isLoggedIn(), false);
    });

    test('returns true when token exists', () {
      when(() => mockStorage.getAuthToken()).thenReturn('mock_token');

      expect(repository.isLoggedIn(), true);
    });
  });
}
