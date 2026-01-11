import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/features/checkout/presentation/providers/address_provider.dart';
import 'package:fashion_ecommerce/data/services/storage_service.dart';
import 'package:fashion_ecommerce/data/models/address_model.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  setUpAll(() {
    registerFallbackValue(
      AddressModel(
        id: 'fallback',
        fullName: '',
        phoneNumber: '',
        streetAddress: '',
        city: '',
        state: '',
        zipCode: '',
        country: '',
      ),
    );
  });

  AddressModel createAddress({String id = 'addr_1', bool isDefault = false}) {
    return AddressModel(
      id: id,
      fullName: 'Test User',
      phoneNumber: '+1234567890',
      streetAddress: '123 Main St',
      city: 'Test City',
      state: 'TS',
      zipCode: '12345',
      country: 'Test Country',
      isDefault: isDefault,
    );
  }

  group('AddressNotifier initialization', () {
    test('loads addresses on creation', () {
      final addresses = [createAddress()];
      when(() => mockStorage.getAddresses()).thenReturn(addresses);

      final notifier = AddressNotifier(mockStorage);

      expect(notifier.state.addresses.length, 1);
      verify(() => mockStorage.getAddresses()).called(1);
    });

    test('sets default as selected when exists', () {
      final addresses = [
        createAddress(id: 'addr_1'),
        createAddress(id: 'addr_2', isDefault: true),
      ];
      when(() => mockStorage.getAddresses()).thenReturn(addresses);

      final notifier = AddressNotifier(mockStorage);

      expect(notifier.state.selectedAddress?.id, 'addr_2');
    });

    test('sets first as selected when no default', () {
      final addresses = [
        createAddress(id: 'addr_1'),
        createAddress(id: 'addr_2'),
      ];
      when(() => mockStorage.getAddresses()).thenReturn(addresses);

      final notifier = AddressNotifier(mockStorage);

      expect(notifier.state.selectedAddress?.id, 'addr_1');
    });

    test('handles empty address list', () {
      when(() => mockStorage.getAddresses()).thenReturn([]);

      final notifier = AddressNotifier(mockStorage);

      expect(notifier.state.addresses, isEmpty);
      expect(notifier.state.selectedAddress, null);
    });
  });

  group('AddressNotifier.saveAddress', () {
    test('saves address and reloads', () async {
      when(() => mockStorage.getAddresses()).thenReturn([]);
      when(() => mockStorage.saveAddress(any())).thenAnswer((_) async {});

      final notifier = AddressNotifier(mockStorage);
      final address = createAddress();

      when(() => mockStorage.getAddresses()).thenReturn([address]);

      await notifier.saveAddress(address);

      verify(() => mockStorage.saveAddress(address)).called(1);
      expect(notifier.state.isLoading, false);
    });

    test('handles save error', () async {
      when(() => mockStorage.getAddresses()).thenReturn([]);
      when(
        () => mockStorage.saveAddress(any()),
      ).thenThrow(Exception('Save failed'));

      final notifier = AddressNotifier(mockStorage);

      await notifier.saveAddress(createAddress());

      expect(notifier.state.error, contains('Save failed'));
      expect(notifier.state.isLoading, false);
    });
  });

  group('AddressNotifier.deleteAddress', () {
    test('deletes address and reloads', () async {
      final addresses = [createAddress()];
      when(() => mockStorage.getAddresses()).thenReturn(addresses);
      when(() => mockStorage.deleteAddress('addr_1')).thenAnswer((_) async {});

      final notifier = AddressNotifier(mockStorage);

      when(() => mockStorage.getAddresses()).thenReturn([]);

      await notifier.deleteAddress('addr_1');

      verify(() => mockStorage.deleteAddress('addr_1')).called(1);
    });

    test('handles delete error', () async {
      when(() => mockStorage.getAddresses()).thenReturn([]);
      when(
        () => mockStorage.deleteAddress(any()),
      ).thenThrow(Exception('Delete failed'));

      final notifier = AddressNotifier(mockStorage);

      await notifier.deleteAddress('addr_1');

      expect(notifier.state.error, contains('Delete failed'));
    });
  });

  group('AddressNotifier.selectAddress', () {
    test('updates selected address', () {
      final addresses = [
        createAddress(id: 'addr_1'),
        createAddress(id: 'addr_2'),
      ];
      when(() => mockStorage.getAddresses()).thenReturn(addresses);

      final notifier = AddressNotifier(mockStorage);
      final newSelected = addresses[1];

      notifier.selectAddress(newSelected);

      expect(notifier.state.selectedAddress?.id, 'addr_2');
    });
  });
}
