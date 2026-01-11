import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email validation', () {
    bool isValidEmail(String email) {
      return email.contains('@') && email.contains('.');
    }

    test('valid email passes', () {
      expect(isValidEmail('test@example.com'), true);
      expect(isValidEmail('user.name@domain.org'), true);
      expect(isValidEmail('a@b.co'), true);
    });

    test('invalid email fails', () {
      expect(isValidEmail(''), false);
      expect(isValidEmail('invalidemail'), false);
      expect(isValidEmail('no@domain'), false);
      expect(isValidEmail('missingdot@domain'), false);
    });
  });

  group('Password validation', () {
    bool isValidPassword(String password) {
      return password.length >= 6;
    }

    test('valid password passes', () {
      expect(isValidPassword('123456'), true);
      expect(isValidPassword('securepassword'), true);
      expect(isValidPassword('P@ssw0rd!'), true);
    });

    test('short password fails', () {
      expect(isValidPassword(''), false);
      expect(isValidPassword('12345'), false);
      expect(isValidPassword('abc'), false);
    });
  });

  group('Phone number validation', () {
    bool isValidPhone(String phone) {
      final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      return cleaned.length >= 10 && RegExp(r'^[+]?\d+$').hasMatch(cleaned);
    }

    test('valid phone numbers pass', () {
      expect(isValidPhone('+1234567890'), true);
      expect(isValidPhone('1234567890'), true);
      expect(isValidPhone('+1 234 567 890'), true);
    });

    test('invalid phone numbers fail', () {
      expect(isValidPhone('123'), false);
      expect(isValidPhone('abc'), false);
      expect(isValidPhone(''), false);
    });
  });

  group('Zip code validation', () {
    bool isValidZipCode(String zipCode) {
      return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode);
    }

    test('valid US zip codes pass', () {
      expect(isValidZipCode('12345'), true);
      expect(isValidZipCode('12345-6789'), true);
    });

    test('invalid zip codes fail', () {
      expect(isValidZipCode('1234'), false);
      expect(isValidZipCode('123456'), false);
      expect(isValidZipCode('abcde'), false);
    });
  });

  group('Card number validation', () {
    bool isValidCardNumber(String cardNumber) {
      final cleaned = cardNumber.replaceAll(' ', '');
      return cleaned.length >= 13 &&
          cleaned.length <= 19 &&
          RegExp(r'^\d+$').hasMatch(cleaned);
    }

    test('valid card numbers pass', () {
      expect(isValidCardNumber('4111111111111111'), true);
      expect(isValidCardNumber('5500 0000 0000 0004'), true);
      expect(isValidCardNumber('378282246310005'), true);
    });

    test('invalid card numbers fail', () {
      expect(isValidCardNumber('123'), false);
      expect(isValidCardNumber('abcd1234567890123'), false);
      expect(isValidCardNumber(''), false);
    });
  });

  group('Expiry date validation', () {
    bool isValidExpiryDate(String expiry) {
      final parts = expiry.split('/');
      if (parts.length != 2) return false;

      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);

      if (month == null || year == null) return false;
      if (month < 1 || month > 12) return false;

      return true;
    }

    test('valid expiry dates pass', () {
      expect(isValidExpiryDate('12/25'), true);
      expect(isValidExpiryDate('01/30'), true);
      expect(isValidExpiryDate('06/26'), true);
    });

    test('invalid expiry dates fail', () {
      expect(isValidExpiryDate(''), false);
      expect(isValidExpiryDate('13/25'), false);
      expect(isValidExpiryDate('00/25'), false);
      expect(isValidExpiryDate('1225'), false);
    });
  });

  group('Price formatting', () {
    String formatPrice(double price) {
      return '\$${price.toStringAsFixed(2)}';
    }

    test('formats whole numbers correctly', () {
      expect(formatPrice(100), '\$100.00');
      expect(formatPrice(0), '\$0.00');
    });

    test('formats decimals correctly', () {
      expect(formatPrice(99.99), '\$99.99');
      expect(formatPrice(10.5), '\$10.50');
    });

    test('rounds to two decimal places', () {
      expect(formatPrice(10.999), '\$11.00');
      expect(formatPrice(10.994), '\$10.99');
    });
  });

  group('Quantity validation', () {
    bool isValidQuantity(int quantity, int maxStock) {
      return quantity > 0 && quantity <= maxStock;
    }

    test('valid quantities pass', () {
      expect(isValidQuantity(1, 10), true);
      expect(isValidQuantity(5, 10), true);
      expect(isValidQuantity(10, 10), true);
    });

    test('invalid quantities fail', () {
      expect(isValidQuantity(0, 10), false);
      expect(isValidQuantity(-1, 10), false);
      expect(isValidQuantity(11, 10), false);
    });
  });

  group('Search query normalization', () {
    String normalizeQuery(String query) {
      return query.trim().toLowerCase();
    }

    test('removes whitespace and lowercases', () {
      expect(normalizeQuery('  Test  '), 'test');
      expect(normalizeQuery('UPPERCASE'), 'uppercase');
      expect(normalizeQuery(' Mixed Case '), 'mixed case');
    });

    test('handles empty string', () {
      expect(normalizeQuery(''), '');
      expect(normalizeQuery('   '), '');
    });
  });
}
