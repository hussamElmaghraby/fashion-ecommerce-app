import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/payment_method_model.dart';

void main() {
  group('PaymentMethodModel', () {
    test('creates card payment with all fields', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111234',
        cardHolderName: 'John Doe',
        expiryDate: '12/25',
        isDefault: true,
      );

      expect(payment.id, 'pm_1');
      expect(payment.type, PaymentType.card);
      expect(payment.cardNumber, '4111111111111234');
      expect(payment.cardHolderName, 'John Doe');
      expect(payment.expiryDate, '12/25');
      expect(payment.isDefault, true);
    });

    test('creates cash payment without card details', () {
      final payment = PaymentMethodModel(id: 'pm_2', type: PaymentType.cash);

      expect(payment.type, PaymentType.cash);
      expect(payment.cardNumber, null);
      expect(payment.isDefault, false);
    });

    test('displayName returns correct text for card', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111234',
      );

      expect(payment.displayName, 'Card ending in 1234');
    });

    test('displayName returns correct text for cash', () {
      final payment = PaymentMethodModel(id: 'pm_1', type: PaymentType.cash);

      expect(payment.displayName, 'Cash on Delivery');
    });

    test('fromJson parses card payment correctly', () {
      final json = {
        'id': 'pm_123',
        'type': 'card',
        'cardNumber': '5555555555554444',
        'cardHolderName': 'Jane Smith',
        'expiryDate': '06/26',
        'isDefault': true,
      };

      final payment = PaymentMethodModel.fromJson(json);

      expect(payment.id, 'pm_123');
      expect(payment.type, PaymentType.card);
      expect(payment.cardNumber, '5555555555554444');
      expect(payment.cardHolderName, 'Jane Smith');
      expect(payment.isDefault, true);
    });

    test('fromJson parses cash payment correctly', () {
      final json = {'id': 'pm_456', 'type': 'cash', 'isDefault': false};

      final payment = PaymentMethodModel.fromJson(json);

      expect(payment.type, PaymentType.cash);
      expect(payment.cardNumber, null);
    });

    test('fromJson handles invalid type gracefully', () {
      final json = {'id': 'pm_1', 'type': 'unknown_type'};

      final payment = PaymentMethodModel.fromJson(json);
      expect(payment.type, PaymentType.card);
    });

    test('fromJson handles null values', () {
      final payment = PaymentMethodModel.fromJson({});

      expect(payment.id, '');
      expect(payment.type, PaymentType.card);
      expect(payment.isDefault, false);
    });

    test('toJson produces correct output for card', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111111',
        cardHolderName: 'Test User',
        expiryDate: '01/28',
        isDefault: true,
      );

      final json = payment.toJson();

      expect(json['id'], 'pm_1');
      expect(json['type'], 'card');
      expect(json['cardNumber'], '4111111111111111');
      expect(json['cardHolderName'], 'Test User');
      expect(json['expiryDate'], '01/28');
      expect(json['isDefault'], true);
    });

    test('toJson produces correct output for cash', () {
      final payment = PaymentMethodModel(id: 'pm_2', type: PaymentType.cash);

      final json = payment.toJson();

      expect(json['type'], 'cash');
      expect(json['cardNumber'], null);
    });

    test('copyWith creates new instance with updates', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111111',
        isDefault: false,
      );

      final updated = payment.copyWith(isDefault: true);

      expect(updated.isDefault, true);
      expect(updated.cardNumber, payment.cardNumber);
    });

    test('copyWith updates card details', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111111',
        expiryDate: '12/24',
      );

      final updated = payment.copyWith(
        cardNumber: '5555555555555555',
        expiryDate: '12/28',
      );

      expect(updated.cardNumber, '5555555555555555');
      expect(updated.expiryDate, '12/28');
    });

    test('copyWith changes type', () {
      final payment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111111',
      );

      final updated = payment.copyWith(type: PaymentType.cash);

      expect(updated.type, PaymentType.cash);
      expect(updated.cardNumber, '4111111111111111');
    });
  });

  group('PaymentType', () {
    test('enum values exist', () {
      expect(PaymentType.values.length, 2);
      expect(PaymentType.values.contains(PaymentType.card), true);
      expect(PaymentType.values.contains(PaymentType.cash), true);
    });

    test('enum index values', () {
      expect(PaymentType.card.index, 0);
      expect(PaymentType.cash.index, 1);
    });
  });
}
