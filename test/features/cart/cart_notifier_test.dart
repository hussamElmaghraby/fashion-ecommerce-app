import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_ecommerce/data/repositories/cart_repository.dart';
import 'package:fashion_ecommerce/data/models/cart_item_model.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
  });

  setUpAll(() {
    registerFallbackValue(
      CartItemModel(
        id: 'fallback',
        product: ProductModel(
          id: 0,
          title: '',
          price: 0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 0, count: 0),
        ),
        quantity: 1,
      ),
    );
  });

  ProductModel createProduct({int id = 1, double price = 50.0}) {
    return ProductModel(
      id: id,
      title: 'Test Product $id',
      price: price,
      description: 'Description',
      category: 'Category',
      image: 'image.jpg',
      rating: RatingModel(rate: 4.0, count: 10),
    );
  }

  CartItemModel createCartItem({
    String id = 'item_1',
    int productId = 1,
    int quantity = 1,
    double price = 50.0,
  }) {
    return CartItemModel(
      id: id,
      product: createProduct(id: productId, price: price),
      quantity: quantity,
    );
  }

  group('CartNotifier initialization', () {
    test('loads cart items on creation', () {
      final items = [createCartItem()];
      when(() => mockRepository.getCartItems()).thenReturn(items);

      final notifier = CartNotifier(mockRepository);

      expect(notifier.state.items.length, 1);
      verify(() => mockRepository.getCartItems()).called(1);
    });

    test('starts with empty cart when no items', () {
      when(() => mockRepository.getCartItems()).thenReturn([]);

      final notifier = CartNotifier(mockRepository);

      expect(notifier.state.items, isEmpty);
    });
  });

  group('CartNotifier.addToCart', () {
    test('adds item and reloads cart', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(() => mockRepository.addToCart(any())).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);
      final item = createCartItem();

      when(() => mockRepository.getCartItems()).thenReturn([item]);

      await notifier.addToCart(item);

      verify(() => mockRepository.addToCart(item)).called(1);
      expect(notifier.state.isLoading, false);
    });

    test('sets loading state during operation', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(() => mockRepository.addToCart(any())).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);
      final item = createCartItem();

      final future = notifier.addToCart(item);

      await future;
      expect(notifier.state.isLoading, false);
    });

    test('handles error during add', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(
        () => mockRepository.addToCart(any()),
      ).thenThrow(Exception('Failed to add'));

      final notifier = CartNotifier(mockRepository);
      final item = createCartItem();

      await notifier.addToCart(item);

      expect(notifier.state.error, contains('Failed to add'));
      expect(notifier.state.isLoading, false);
    });
  });

  group('CartNotifier.removeFromCart', () {
    test('removes item and reloads cart', () async {
      final item = createCartItem();
      when(() => mockRepository.getCartItems()).thenReturn([item]);
      when(
        () => mockRepository.removeFromCart('item_1'),
      ).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);

      when(() => mockRepository.getCartItems()).thenReturn([]);

      await notifier.removeFromCart('item_1');

      verify(() => mockRepository.removeFromCart('item_1')).called(1);
    });

    test('handles error during remove', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(
        () => mockRepository.removeFromCart(any()),
      ).thenThrow(Exception('Remove failed'));

      final notifier = CartNotifier(mockRepository);

      await notifier.removeFromCart('item_1');

      expect(notifier.state.error, contains('Remove failed'));
    });
  });

  group('CartNotifier.updateQuantity', () {
    test('updates quantity for existing item', () async {
      final item = createCartItem(quantity: 1);
      when(() => mockRepository.getCartItems()).thenReturn([item]);
      when(
        () => mockRepository.updateCartItemQuantity('item_1', 5),
      ).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);

      await notifier.updateQuantity('item_1', 5);

      verify(
        () => mockRepository.updateCartItemQuantity('item_1', 5),
      ).called(1);
    });

    test('removes item when quantity is zero', () async {
      final item = createCartItem(quantity: 1);
      when(() => mockRepository.getCartItems()).thenReturn([item]);
      when(
        () => mockRepository.removeFromCart('item_1'),
      ).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);

      when(() => mockRepository.getCartItems()).thenReturn([]);

      await notifier.updateQuantity('item_1', 0);

      verify(() => mockRepository.removeFromCart('item_1')).called(1);
    });

    test('removes item when quantity is negative', () async {
      final item = createCartItem(quantity: 1);
      when(() => mockRepository.getCartItems()).thenReturn([item]);
      when(
        () => mockRepository.removeFromCart('item_1'),
      ).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);

      when(() => mockRepository.getCartItems()).thenReturn([]);

      await notifier.updateQuantity('item_1', -1);

      verify(() => mockRepository.removeFromCart('item_1')).called(1);
    });
  });

  group('CartNotifier.clearCart', () {
    test('clears all items', () async {
      final items = [
        createCartItem(id: 'item_1'),
        createCartItem(id: 'item_2', productId: 2),
      ];
      when(() => mockRepository.getCartItems()).thenReturn(items);
      when(() => mockRepository.clearCart()).thenAnswer((_) async {});

      final notifier = CartNotifier(mockRepository);

      await notifier.clearCart();

      expect(notifier.state.items, isEmpty);
      verify(() => mockRepository.clearCart()).called(1);
    });

    test('handles error during clear', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(
        () => mockRepository.clearCart(),
      ).thenThrow(Exception('Clear failed'));

      final notifier = CartNotifier(mockRepository);

      await notifier.clearCart();

      expect(notifier.state.error, contains('Clear failed'));
    });
  });

  group('CartNotifier.clearError', () {
    test('clears error from state', () async {
      when(() => mockRepository.getCartItems()).thenReturn([]);
      when(
        () => mockRepository.addToCart(any()),
      ).thenThrow(Exception('Some error'));

      final notifier = CartNotifier(mockRepository);
      await notifier.addToCart(createCartItem());

      expect(notifier.state.error, isNotNull);

      notifier.clearError();

      expect(notifier.state.error, null);
    });
  });
}
