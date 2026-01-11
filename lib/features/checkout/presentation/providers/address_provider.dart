import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../../../data/models/address_model.dart';

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((
  ref,
) {
  return AddressNotifier(ref.read(storageServiceProvider));
});

// Provider for addresses list as AsyncValue
final addressesProvider = Provider<AsyncValue<List<AddressModel>>>((ref) {
  final addressState = ref.watch(addressProvider);

  if (addressState.isLoading) {
    return const AsyncValue.loading();
  }

  if (addressState.error != null) {
    return AsyncValue.error(addressState.error!, StackTrace.current);
  }

  return AsyncValue.data(addressState.addresses);
});

class AddressState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final bool isLoading;
  final String? error;

  AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.error,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    bool? isLoading,
    String? error,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final dynamic _storageService;

  AddressNotifier(this._storageService) : super(AddressState()) {
    _loadAddresses();
  }

  void _loadAddresses() {
    final List<AddressModel> addresses = _storageService.getAddresses();
    final defaultAddress = addresses.isNotEmpty
        ? addresses.firstWhere(
            (AddressModel a) => a.isDefault,
            orElse: () => addresses.first,
          )
        : null;

    state = state.copyWith(
      addresses: addresses,
      selectedAddress: defaultAddress,
    );
  }

  Future<void> saveAddress(AddressModel address) async {
    state = state.copyWith(isLoading: true);

    try {
      await _storageService.saveAddress(address);
      _loadAddresses();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteAddress(String addressId) async {
    state = state.copyWith(isLoading: true);

    try {
      await _storageService.deleteAddress(addressId);
      _loadAddresses();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }
}
