import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final StorageService _storageService;

  AuthRepository(this._storageService);

  // Simulate login
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Create mock user
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: 'John Doe',
      email: email,
      phoneNumber: '+1234567890',
    );

    // Save user and token
    await _storageService.saveUser(user);
    await _storageService.saveAuthToken('mock_token_${user.id}');

    return user;
  }

  // Simulate sign up
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Create mock user
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
    );

    // Save user and token
    await _storageService.saveUser(user);
    await _storageService.saveAuthToken('mock_token_${user.id}');

    return user;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Please enter a valid email');
    }

    // Mock success
  }

  // Verify reset code
  Future<bool> verifyResetCode(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return code.length == 4;
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    if (newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.deleteAuthToken();
    await _storageService.deleteUser();
  }

  // Get current user
  UserModel? getCurrentUser() {
    return _storageService.getUser();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _storageService.getAuthToken() != null;
  }
}
