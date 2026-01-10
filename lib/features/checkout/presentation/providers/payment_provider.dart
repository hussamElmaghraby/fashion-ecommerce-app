import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../../../data/models/payment_method_model.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier(ref.read(storageServiceProvider));
});

// Provider for payment methods list as AsyncValue
final paymentMethodsProvider = Provider<AsyncValue<List<PaymentMethodModel>>>((
  ref,
) {
  final paymentState = ref.watch(paymentProvider);

  if (paymentState.isLoading) {
    return const AsyncValue.loading();
  }

  if (paymentState.error != null) {
    return AsyncValue.error(paymentState.error!, StackTrace.current);
  }

  return AsyncValue.data(paymentState.paymentMethods);
});

class PaymentState {
  final List<PaymentMethodModel> paymentMethods;
  final PaymentMethodModel? selectedPayment;
  final bool isLoading;
  final String? error;

  PaymentState({
    this.paymentMethods = const [],
    this.selectedPayment,
    this.isLoading = false,
    this.error,
  });

  PaymentState copyWith({
    List<PaymentMethodModel>? paymentMethods,
    PaymentMethodModel? selectedPayment,
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final dynamic _storageService;

  PaymentNotifier(this._storageService) : super(PaymentState()) {
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    final paymentMethods = _storageService.getPaymentMethods();
    final defaultPayment = _storageService.getDefaultPaymentMethod();

    state = state.copyWith(
      paymentMethods: paymentMethods,
      selectedPayment: defaultPayment,
    );
  }

  Future<void> savePaymentMethod(PaymentMethodModel payment) async {
    state = state.copyWith(isLoading: true);

    try {
      await _storageService.savePaymentMethod(payment);
      _loadPaymentMethods();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deletePaymentMethod(String paymentId) async {
    state = state.copyWith(isLoading: true);

    try {
      await _storageService.deletePaymentMethod(paymentId);
      _loadPaymentMethods();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectPayment(PaymentMethodModel payment) {
    state = state.copyWith(selectedPayment: payment);
  }
}
