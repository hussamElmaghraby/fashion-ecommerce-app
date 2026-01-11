import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    late Map<String, dynamic> validJson;

    setUp(() {
      validJson = {
        'id': 'user_123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'phoneNumber': '+1234567890',
        'profileImage': 'https://example.com/avatar.jpg',
      };
    });

    test('creates instance with required fields', () {
      final user = UserModel(
        id: 'user_1',
        fullName: 'Jane Doe',
        email: 'jane@test.com',
      );

      expect(user.id, 'user_1');
      expect(user.fullName, 'Jane Doe');
      expect(user.email, 'jane@test.com');
      expect(user.phoneNumber, null);
      expect(user.profileImage, null);
    });

    test('creates instance with all fields', () {
      final user = UserModel(
        id: 'user_1',
        fullName: 'John',
        email: 'john@test.com',
        phoneNumber: '+9876543210',
        profileImage: 'profile.jpg',
      );

      expect(user.phoneNumber, '+9876543210');
      expect(user.profileImage, 'profile.jpg');
    });

    test('fromJson parses valid JSON correctly', () {
      final user = UserModel.fromJson(validJson);

      expect(user.id, 'user_123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phoneNumber, '+1234567890');
      expect(user.profileImage, 'https://example.com/avatar.jpg');
    });

    test('fromJson handles missing optional fields', () {
      final minimalJson = {
        'id': 'user_1',
        'fullName': 'Test User',
        'email': 'test@test.com',
      };

      final user = UserModel.fromJson(minimalJson);

      expect(user.phoneNumber, null);
      expect(user.profileImage, null);
    });

    test('fromJson handles null values gracefully', () {
      final user = UserModel.fromJson({});

      expect(user.id, '');
      expect(user.fullName, '');
      expect(user.email, '');
    });

    test('toJson produces correct output', () {
      final user = UserModel.fromJson(validJson);
      final json = user.toJson();

      expect(json['id'], 'user_123');
      expect(json['fullName'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phoneNumber'], '+1234567890');
      expect(json['profileImage'], 'https://example.com/avatar.jpg');
    });

    test('toJson includes null values for optional fields', () {
      final user = UserModel(
        id: 'user_1',
        fullName: 'Test',
        email: 'test@test.com',
      );
      final json = user.toJson();

      expect(json.containsKey('phoneNumber'), true);
      expect(json['phoneNumber'], null);
    });

    test('copyWith creates new instance with updates', () {
      final user = UserModel.fromJson(validJson);
      final updated = user.copyWith(fullName: 'Jane Smith');

      expect(updated.fullName, 'Jane Smith');
      expect(updated.id, user.id);
      expect(updated.email, user.email);
    });

    test('copyWith updates multiple fields', () {
      final user = UserModel(
        id: 'user_1',
        fullName: 'Original',
        email: 'original@test.com',
      );

      final updated = user.copyWith(
        fullName: 'Updated Name',
        email: 'updated@test.com',
        phoneNumber: '+111222333',
      );

      expect(updated.fullName, 'Updated Name');
      expect(updated.email, 'updated@test.com');
      expect(updated.phoneNumber, '+111222333');
    });

    test('copyWith preserves values when no changes specified', () {
      final user = UserModel.fromJson(validJson);
      final copy = user.copyWith();

      expect(copy.id, user.id);
      expect(copy.fullName, user.fullName);
      expect(copy.email, user.email);
      expect(copy.phoneNumber, user.phoneNumber);
      expect(copy.profileImage, user.profileImage);
    });
  });
}
