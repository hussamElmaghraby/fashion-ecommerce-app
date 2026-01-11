import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/address_model.dart';

void main() {
  group('AddressModel', () {
    late Map<String, dynamic> validJson;
    late AddressModel testAddress;

    setUp(() {
      validJson = {
        'id': 'addr_123',
        'fullName': 'John Doe',
        'phoneNumber': '+1234567890',
        'streetAddress': '123 Main St',
        'city': 'New York',
        'state': 'NY',
        'zipCode': '10001',
        'country': 'USA',
        'isDefault': true,
      };

      testAddress = AddressModel(
        id: 'addr_1',
        fullName: 'Jane Doe',
        phoneNumber: '+9876543210',
        streetAddress: '456 Oak Ave',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'USA',
      );
    });

    test('creates instance with required fields', () {
      expect(testAddress.id, 'addr_1');
      expect(testAddress.fullName, 'Jane Doe');
      expect(testAddress.city, 'Los Angeles');
      expect(testAddress.isDefault, false);
    });

    test('creates instance with isDefault true', () {
      final address = AddressModel(
        id: 'addr_1',
        fullName: 'Test',
        phoneNumber: '123',
        streetAddress: 'Street',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
        isDefault: true,
      );

      expect(address.isDefault, true);
    });

    test('fullAddress getter returns formatted string', () {
      expect(
        testAddress.fullAddress,
        '456 Oak Ave, Los Angeles, CA 90001, USA',
      );
    });

    test('fromJson parses valid JSON correctly', () {
      final address = AddressModel.fromJson(validJson);

      expect(address.id, 'addr_123');
      expect(address.fullName, 'John Doe');
      expect(address.phoneNumber, '+1234567890');
      expect(address.streetAddress, '123 Main St');
      expect(address.city, 'New York');
      expect(address.state, 'NY');
      expect(address.zipCode, '10001');
      expect(address.country, 'USA');
      expect(address.isDefault, true);
    });

    test('fromJson handles null values gracefully', () {
      final address = AddressModel.fromJson({});

      expect(address.id, '');
      expect(address.fullName, '');
      expect(address.streetAddress, '');
      expect(address.isDefault, false);
    });

    test('fromJson handles missing isDefault', () {
      final json = {...validJson};
      json.remove('isDefault');

      final address = AddressModel.fromJson(json);
      expect(address.isDefault, false);
    });

    test('toJson produces correct output', () {
      final json = testAddress.toJson();

      expect(json['id'], 'addr_1');
      expect(json['fullName'], 'Jane Doe');
      expect(json['phoneNumber'], '+9876543210');
      expect(json['streetAddress'], '456 Oak Ave');
      expect(json['city'], 'Los Angeles');
      expect(json['state'], 'CA');
      expect(json['zipCode'], '90001');
      expect(json['country'], 'USA');
      expect(json['isDefault'], false);
    });

    test('copyWith creates new instance with updates', () {
      final updated = testAddress.copyWith(city: 'San Francisco');

      expect(updated.city, 'San Francisco');
      expect(updated.id, testAddress.id);
      expect(updated.fullName, testAddress.fullName);
    });

    test('copyWith updates isDefault', () {
      final updated = testAddress.copyWith(isDefault: true);

      expect(updated.isDefault, true);
      expect(testAddress.isDefault, false);
    });

    test('copyWith updates multiple fields', () {
      final updated = testAddress.copyWith(
        streetAddress: '789 Pine Rd',
        city: 'Chicago',
        state: 'IL',
        zipCode: '60601',
      );

      expect(updated.streetAddress, '789 Pine Rd');
      expect(updated.city, 'Chicago');
      expect(updated.state, 'IL');
      expect(updated.zipCode, '60601');
      expect(updated.country, testAddress.country);
    });

    test('copyWith preserves values when no changes', () {
      final copy = testAddress.copyWith();

      expect(copy.id, testAddress.id);
      expect(copy.fullName, testAddress.fullName);
      expect(copy.phoneNumber, testAddress.phoneNumber);
      expect(copy.streetAddress, testAddress.streetAddress);
    });

    test('fullAddress getter formats correctly with different data', () {
      final address = AddressModel(
        id: 'test',
        fullName: 'Test',
        phoneNumber: '123',
        streetAddress: 'Apt 5, Building A',
        city: 'Boston',
        state: 'MA',
        zipCode: '02101',
        country: 'United States',
      );

      expect(
        address.fullAddress,
        'Apt 5, Building A, Boston, MA 02101, United States',
      );
    });
  });
}
