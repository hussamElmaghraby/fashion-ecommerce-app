import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/features/checkout/presentation/providers/payment_provider.dart';
import 'package:fashion_ecommerce/data/services/storage_service.dart';
import 'package:fashion_ecommerce/data/models/payment_method_model.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  setUpAll(() {
    registerFallbackValue(
      PaymentMethodModel(id: 'fallback', type: PaymentType.card),
    );
  });

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

  group('PaymentNotifier initialization', () {
    test('loads payment methods on creation', () {
      final methods = [createCardPayment()];
      when(() => mockStorage.getPaymentMethods()).thenReturn(methods);
      when(
        () => mockStorage.getDefaultPaymentMethod(),
      ).thenReturn(methods.first);

      final notifier = PaymentNotifier(mockStorage);

      expect(notifier.state.paymentMethods.length, 1);
      verify(() => mockStorage.getPaymentMethods()).called(1);
    });

    test('sets default as selected when exists', () {
      final methods = [
        createCardPayment(id: 'pm_1'),
        createCardPayment(id: 'pm_2', isDefault: true),
      ];
      when(() => mockStorage.getPaymentMethods()).thenReturn(methods);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(methods[1]);

      final notifier = PaymentNotifier(mockStorage);

      expect(notifier.state.selectedPayment?.id, 'pm_2');
    });

    test('handles empty payment methods', () {
      when(() => mockStorage.getPaymentMethods()).thenReturn([]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(null);

      final notifier = PaymentNotifier(mockStorage);

      expect(notifier.state.paymentMethods, isEmpty);
      expect(notifier.state.selectedPayment, null);
    });
  });

  group('PaymentNotifier.savePaymentMethod', () {
    test('saves payment and reloads', () async {
      when(() => mockStorage.getPaymentMethods()).thenReturn([]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(null);
      when(() => mockStorage.savePaymentMethod(any())).thenAnswer((_) async {});

      final notifier = PaymentNotifier(mockStorage);
      final payment = createCardPayment();

      when(() => mockStorage.getPaymentMethods()).thenReturn([payment]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(payment);

      await notifier.savePaymentMethod(payment);

      verify(() => mockStorage.savePaymentMethod(payment)).called(1);
      expect(notifier.state.isLoading, false);
    });

    test('handles save error', () async {
      when(() => mockStorage.getPaymentMethods()).thenReturn([]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(null);
      when(
        () => mockStorage.savePaymentMethod(any()),
      ).thenThrow(Exception('Save failed'));

      final notifier = PaymentNotifier(mockStorage);

      await notifier.savePaymentMethod(createCardPayment());

      expect(notifier.state.error, contains('Save failed'));
      expect(notifier.state.isLoading, false);
    });
  });

  group('PaymentNotifier.deletePaymentMethod', () {
    test('deletes payment and reloads', () async {
      final methods = [createCardPayment()];
      when(() => mockStorage.getPaymentMethods()).thenReturn(methods);
      when(
        () => mockStorage.getDefaultPaymentMethod(),
      ).thenReturn(methods.first);
      when(
        () => mockStorage.deletePaymentMethod('pm_1'),
      ).thenAnswer((_) async {});

      final notifier = PaymentNotifier(mockStorage);

      when(() => mockStorage.getPaymentMethods()).thenReturn([]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(null);

      await notifier.deletePaymentMethod('pm_1');

      verify(() => mockStorage.deletePaymentMethod('pm_1')).called(1);
    });

    test('handles delete error', () async {
      when(() => mockStorage.getPaymentMethods()).thenReturn([]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(null);
      when(
        () => mockStorage.deletePaymentMethod(any()),
      ).thenThrow(Exception('Delete failed'));

      final notifier = PaymentNotifier(mockStorage);

      await notifier.deletePaymentMethod('pm_1');

      expect(notifier.state.error, contains('Delete failed'));
    });
  });

  group('PaymentNotifier.selectPayment', () {
    test('updates selected payment', () {
      final methods = [
        createCardPayment(id: 'pm_1'),
        createCardPayment(id: 'pm_2'),
      ];
      when(() => mockStorage.getPaymentMethods()).thenReturn(methods);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(methods[0]);

      final notifier = PaymentNotifier(mockStorage);
      final newSelected = methods[1];

      notifier.selectPayment(newSelected);

      expect(notifier.state.selectedPayment?.id, 'pm_2');
    });
  });

  group('Payment type handling', () {
    test('handles cash payment type', () {
      final cashPayment = PaymentMethodModel(
        id: 'pm_cash',
        type: PaymentType.cash,
      );
      when(() => mockStorage.getPaymentMethods()).thenReturn([cashPayment]);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(cashPayment);

      final notifier = PaymentNotifier(mockStorage);

      expect(notifier.state.selectedPayment?.type, PaymentType.cash);
    });

    test('handles mixed payment types', () {
      final methods = [
        createCardPayment(id: 'pm_1'),
        PaymentMethodModel(id: 'pm_cash', type: PaymentType.cash),
      ];
      when(() => mockStorage.getPaymentMethods()).thenReturn(methods);
      when(() => mockStorage.getDefaultPaymentMethod()).thenReturn(methods[0]);

      final notifier = PaymentNotifier(mockStorage);

      expect(notifier.state.paymentMethods.length, 2);
      expect(
        notifier.state.paymentMethods.any((p) => p.type == PaymentType.cash),
        true,
      );
    });
  });
}
