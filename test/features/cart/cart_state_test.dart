import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_ecommerce/data/models/cart_item_model.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

void main() {
  group('CartState', () {
    ProductModel createProduct({double price = 50.0}) {
      return ProductModel(
        id: 1,
        title: 'Test',
        price: price,
        description: 'Desc',
        category: 'cat',
        image: 'img.jpg',
        rating: RatingModel(rate: 4.0, count: 10),
      );
    }

    CartItemModel createItem({
      String id = 'item_1',
      double price = 50.0,
      int quantity = 1,
    }) {
      return CartItemModel(
        id: id,
        product: createProduct(price: price),
        quantity: quantity,
      );
    }

    test('initial state has empty items', () {
      final state = CartState();

      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('subtotal calculates correctly for single item', () {
      final state = CartState(items: [createItem(price: 50.0, quantity: 2)]);

      expect(state.subtotal, 100.0);
    });

    test('subtotal calculates correctly for multiple items', () {
      final state = CartState(
        items: [
          createItem(id: 'item_1', price: 30.0, quantity: 2),
          createItem(id: 'item_2', price: 50.0, quantity: 1),
        ],
      );

      expect(state.subtotal, 110.0);
    });

    test('subtotal returns zero for empty cart', () {
      final state = CartState();

      expect(state.subtotal, 0.0);
    });

    test('shipping returns zero', () {
      final state = CartState();

      expect(state.shipping, 0.0);
    });

    test('tax calculates 5% of subtotal', () {
      final state = CartState(items: [createItem(price: 100.0, quantity: 1)]);

      expect(state.tax, 5.0);
    });

    test('total includes subtotal, shipping and tax', () {
      final state = CartState(items: [createItem(price: 100.0, quantity: 1)]);

      expect(state.total, 105.0);
    });

    test('itemCount sums all quantities', () {
      final state = CartState(
        items: [
          createItem(id: 'item_1', quantity: 2),
          createItem(id: 'item_2', quantity: 3),
        ],
      );

      expect(state.itemCount, 5);
    });

    test('itemCount returns zero for empty cart', () {
      final state = CartState();

      expect(state.itemCount, 0);
    });

    test('copyWith updates items', () {
      final state = CartState();
      final updated = state.copyWith(items: [createItem()]);

      expect(updated.items.length, 1);
      expect(state.items.length, 0);
    });

    test('copyWith updates isLoading', () {
      final state = CartState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
      expect(state.isLoading, false);
    });

    test('copyWith updates error', () {
      final state = CartState();
      final updated = state.copyWith(error: 'Something went wrong');

      expect(updated.error, 'Something went wrong');
      expect(state.error, null);
    });

    test('copyWith clears error when set to null', () {
      final state = CartState(error: 'Error');
      final updated = state.copyWith(error: null);

      expect(updated.error, null);
    });

    test('copyWith preserves other values', () {
      final items = [createItem()];
      final state = CartState(items: items, isLoading: true);
      final updated = state.copyWith(error: 'Error');

      expect(updated.items.length, 1);
      expect(updated.isLoading, true);
    });
  });

  group('CartState calculations edge cases', () {
    test('handles high precision prices', () {
      final item = CartItemModel(
        id: 'item_1',
        product: ProductModel(
          id: 1,
          title: 'Test',
          price: 19.99,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 0, count: 0),
        ),
        quantity: 3,
      );

      final state = CartState(items: [item]);

      expect(state.subtotal, closeTo(59.97, 0.01));
    });

    test('handles large quantities', () {
      final item = CartItemModel(
        id: 'item_1',
        product: ProductModel(
          id: 1,
          title: 'Test',
          price: 10.0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 0, count: 0),
        ),
        quantity: 1000,
      );

      final state = CartState(items: [item]);

      expect(state.subtotal, 10000.0);
      expect(state.tax, 500.0);
    });
  });
}
