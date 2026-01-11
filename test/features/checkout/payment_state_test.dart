import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/features/checkout/presentation/providers/payment_provider.dart';
import 'package:fashion_ecommerce/data/models/payment_method_model.dart';

void main() {
  group('PaymentState', () {
    PaymentMethodModel createCardPayment({
      String id = 'pm_1',
      bool isDefault = false,
    }) {
      return PaymentMethodModel(
        id: id,
        type: PaymentType.card,
        cardNumber: '4111111111111111',
        cardHolderName: 'Test User',
        expiryDate: '12/25',
        isDefault: isDefault,
      );
    }

    PaymentMethodModel createCashPayment({String id = 'pm_cash'}) {
      return PaymentMethodModel(id: id, type: PaymentType.cash);
    }

    test('initial state has empty payment methods', () {
      final state = PaymentState();

      expect(state.paymentMethods, isEmpty);
      expect(state.selectedPayment, null);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('state with payment methods', () {
      final methods = [
        createCardPayment(id: 'pm_1'),
        createCardPayment(id: 'pm_2'),
        createCashPayment(),
      ];

      final state = PaymentState(paymentMethods: methods);

      expect(state.paymentMethods.length, 3);
    });

    test('state with selected payment', () {
      final payment = createCardPayment();
      final state = PaymentState(
        paymentMethods: [payment],
        selectedPayment: payment,
      );

      expect(state.selectedPayment?.id, 'pm_1');
    });

    test('copyWith updates paymentMethods', () {
      final state = PaymentState();
      final methods = [createCardPayment()];
      final updated = state.copyWith(paymentMethods: methods);

      expect(updated.paymentMethods.length, 1);
      expect(state.paymentMethods.length, 0);
    });

    test('copyWith updates selectedPayment', () {
      final payment = createCardPayment();
      final state = PaymentState(paymentMethods: [payment]);
      final updated = state.copyWith(selectedPayment: payment);

      expect(updated.selectedPayment?.id, 'pm_1');
    });

    test('copyWith updates isLoading', () {
      final state = PaymentState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
    });

    test('copyWith updates error', () {
      final state = PaymentState();
      final updated = state.copyWith(error: 'Payment failed');

      expect(updated.error, 'Payment failed');
    });

    test('copyWith preserves other values', () {
      final methods = [createCardPayment()];
      final state = PaymentState(paymentMethods: methods, isLoading: true);
      final updated = state.copyWith(error: 'Error');

      expect(updated.paymentMethods.length, 1);
      expect(updated.isLoading, true);
    });
  });

  group('Payment selection logic', () {
    test('finds default payment from list', () {
      final methods = [
        PaymentMethodModel(
          id: 'pm_1',
          type: PaymentType.card,
          cardNumber: '4111111111111111',
        ),
        PaymentMethodModel(
          id: 'pm_2',
          type: PaymentType.card,
          cardNumber: '5555555555555555',
          isDefault: true,
        ),
      ];

      final defaultPayment = methods.firstWhere(
        (p) => p.isDefault,
        orElse: () => methods.first,
      );

      expect(defaultPayment.id, 'pm_2');
    });

    test('falls back to first when no default', () {
      final methods = [
        PaymentMethodModel(
          id: 'pm_1',
          type: PaymentType.card,
          cardNumber: '4111111111111111',
        ),
        PaymentMethodModel(
          id: 'pm_2',
          type: PaymentType.card,
          cardNumber: '5555555555555555',
        ),
      ];

      final defaultPayment = methods.firstWhere(
        (p) => p.isDefault,
        orElse: () => methods.first,
      );

      expect(defaultPayment.id, 'pm_1');
    });
  });

  group('Payment type filtering', () {
    test('filters card payments only', () {
      final methods = [
        PaymentMethodModel(id: 'pm_1', type: PaymentType.card),
        PaymentMethodModel(id: 'pm_2', type: PaymentType.cash),
        PaymentMethodModel(id: 'pm_3', type: PaymentType.card),
      ];

      final cards = methods.where((p) => p.type == PaymentType.card).toList();

      expect(cards.length, 2);
    });

    test('finds cash payment', () {
      final methods = [
        PaymentMethodModel(id: 'pm_1', type: PaymentType.card),
        PaymentMethodModel(id: 'pm_2', type: PaymentType.cash),
      ];

      final hasCash = methods.any((p) => p.type == PaymentType.cash);

      expect(hasCash, true);
    });
  });

  group('Payment management operations', () {
    test('add new payment to empty list', () {
      final methods = <PaymentMethodModel>[];
      final newPayment = PaymentMethodModel(
        id: 'pm_1',
        type: PaymentType.card,
        cardNumber: '4111111111111111',
      );

      methods.add(newPayment);

      expect(methods.length, 1);
    });

    test('delete payment from list', () {
      final methods = [
        PaymentMethodModel(id: 'pm_1', type: PaymentType.card),
        PaymentMethodModel(id: 'pm_2', type: PaymentType.cash),
      ];

      methods.removeWhere((p) => p.id == 'pm_1');

      expect(methods.length, 1);
      expect(methods.first.type, PaymentType.cash);
    });

    test('update default payment clears previous default', () {
      final methods = [
        PaymentMethodModel(id: 'pm_1', type: PaymentType.card, isDefault: true),
        PaymentMethodModel(
          id: 'pm_2',
          type: PaymentType.card,
          isDefault: false,
        ),
      ];

      final updatedMethods = methods.map((p) {
        if (p.id == 'pm_1') {
          return p.copyWith(isDefault: false);
        }
        if (p.id == 'pm_2') {
          return p.copyWith(isDefault: true);
        }
        return p;
      }).toList();

      expect(updatedMethods[0].isDefault, false);
      expect(updatedMethods[1].isDefault, true);
    });
  });
}
