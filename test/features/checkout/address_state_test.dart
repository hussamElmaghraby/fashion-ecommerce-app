import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/features/checkout/presentation/providers/address_provider.dart';
import 'package:fashion_ecommerce/data/models/address_model.dart';

void main() {
  group('AddressState', () {
    AddressModel createAddress({String id = 'addr_1', bool isDefault = false}) {
      return AddressModel(
        id: id,
        fullName: 'Test User',
        phoneNumber: '+1234567890',
        streetAddress: '123 Test St',
        city: 'Test City',
        state: 'TS',
        zipCode: '12345',
        country: 'Test Country',
        isDefault: isDefault,
      );
    }

    test('initial state has empty addresses', () {
      final state = AddressState();

      expect(state.addresses, isEmpty);
      expect(state.selectedAddress, null);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('state with addresses', () {
      final addresses = [
        createAddress(id: 'addr_1'),
        createAddress(id: 'addr_2'),
      ];

      final state = AddressState(addresses: addresses);

      expect(state.addresses.length, 2);
    });

    test('state with selected address', () {
      final address = createAddress();
      final state = AddressState(
        addresses: [address],
        selectedAddress: address,
      );

      expect(state.selectedAddress?.id, 'addr_1');
    });

    test('copyWith updates addresses', () {
      final state = AddressState();
      final addresses = [createAddress()];
      final updated = state.copyWith(addresses: addresses);

      expect(updated.addresses.length, 1);
      expect(state.addresses.length, 0);
    });

    test('copyWith updates selectedAddress', () {
      final address = createAddress();
      final state = AddressState(addresses: [address]);
      final updated = state.copyWith(selectedAddress: address);

      expect(updated.selectedAddress?.id, 'addr_1');
      expect(state.selectedAddress, null);
    });

    test('copyWith updates isLoading', () {
      final state = AddressState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
    });

    test('copyWith updates error', () {
      final state = AddressState();
      final updated = state.copyWith(error: 'Failed to save');

      expect(updated.error, 'Failed to save');
    });

    test('copyWith preserves other values', () {
      final addresses = [createAddress()];
      final state = AddressState(addresses: addresses, isLoading: true);
      final updated = state.copyWith(error: 'Error');

      expect(updated.addresses.length, 1);
      expect(updated.isLoading, true);
    });
  });

  group('Address selection logic', () {
    test('finds default address from list', () {
      final addresses = [
        AddressModel(
          id: 'addr_1',
          fullName: 'User 1',
          phoneNumber: '123',
          streetAddress: 'St 1',
          city: 'City',
          state: 'ST',
          zipCode: '11111',
          country: 'Country',
        ),
        AddressModel(
          id: 'addr_2',
          fullName: 'User 2',
          phoneNumber: '456',
          streetAddress: 'St 2',
          city: 'City',
          state: 'ST',
          zipCode: '22222',
          country: 'Country',
          isDefault: true,
        ),
      ];

      final defaultAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );

      expect(defaultAddress.id, 'addr_2');
    });

    test('falls back to first when no default', () {
      final addresses = [
        AddressModel(
          id: 'addr_1',
          fullName: 'User 1',
          phoneNumber: '123',
          streetAddress: 'St 1',
          city: 'City',
          state: 'ST',
          zipCode: '11111',
          country: 'Country',
        ),
        AddressModel(
          id: 'addr_2',
          fullName: 'User 2',
          phoneNumber: '456',
          streetAddress: 'St 2',
          city: 'City',
          state: 'ST',
          zipCode: '22222',
          country: 'Country',
        ),
      ];

      final defaultAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );

      expect(defaultAddress.id, 'addr_1');
    });
  });

  group('Address management operations', () {
    test('add new address to empty list', () {
      final addresses = <AddressModel>[];
      final newAddress = AddressModel(
        id: 'addr_1',
        fullName: 'New User',
        phoneNumber: '123',
        streetAddress: 'New St',
        city: 'City',
        state: 'ST',
        zipCode: '12345',
        country: 'Country',
      );

      addresses.add(newAddress);

      expect(addresses.length, 1);
    });

    test('delete address from list', () {
      final addresses = [
        AddressModel(
          id: 'addr_1',
          fullName: 'User 1',
          phoneNumber: '123',
          streetAddress: 'St 1',
          city: 'City',
          state: 'ST',
          zipCode: '11111',
          country: 'Country',
        ),
        AddressModel(
          id: 'addr_2',
          fullName: 'User 2',
          phoneNumber: '456',
          streetAddress: 'St 2',
          city: 'City',
          state: 'ST',
          zipCode: '22222',
          country: 'Country',
        ),
      ];

      addresses.removeWhere((a) => a.id == 'addr_1');

      expect(addresses.length, 1);
      expect(addresses.first.id, 'addr_2');
    });
  });
}
