// import 'package:flutter_test/flutter_test.dart';
// import 'package:fashion_ecommerce/data/repositories/cart_repository.dart';
// import 'package:fashion_ecommerce/data/models/cart_item_model.dart';
// import 'package:fashion_ecommerce/data/models/product_model.dart';
// import 'package:uuid/uuid.dart';
//
// // Mock Storage Service for testing
// class MockStorageService {
//   final List<CartItemModel> _items = [];
//
//   Future<void> addToCart(CartItemModel item) async {
//     _items.add(item);
//   }
//
//   Future<void> removeFromCart(String itemId) async {
//     _items.removeWhere((i) => i.id == itemId);
//   }
//
//   Future<void> updateCartItem(CartItemModel item) async {
//     final index = _items.indexWhere((i) => i.id == item.id);
//     if (index != -1) {
//       _items[index] = item;
//     }
//   }
//
//   Future<void> clearCart() async {
//     _items.clear();
//   }
//
//   List<CartItemModel> getCartItems() {
//     return List.from(_items);
//   }
// }
//
// void main() {
//   late CartRepository cartRepository;
//   late MockStorageService mockStorageService;
//
//   setUp(() {
//     mockStorageService = MockStorageService();
//     cartRepository = CartRepository(mockStorageService);
//   });
//
//   group('CartRepository Tests', () {
//     test('should add item to cart', () async {
//       // Arrange
//       final product = ProductModel(
//         id: 1,
//         title: 'Test Product',
//         price: 99.99,
//         description: 'Test Description',
//         category: 'Test Category',
//         image: 'https://test.com/image.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final cartItem = CartItemModel(
//         id: const Uuid().v4(),
//         product: product,
//         quantity: 1,
//       );
//
//       // Act
//       await cartRepository.addToCart(cartItem);
//       final items = cartRepository.getCartItems();
//
//       // Assert
//       expect(items.length, 1);
//       expect(items.first.product.id, product.id);
//       expect(items.first.quantity, 1);
//     });
//
//     test('should update quantity when adding same item', () async {
//       // Arrange
//       final product = ProductModel(
//         id: 1,
//         title: 'Test Product',
//         price: 99.99,
//         description: 'Test Description',
//         category: 'Test Category',
//         image: 'https://test.com/image.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final cartItem1 = CartItemModel(
//         id: 'test-id-1',
//         product: product,
//         quantity: 1,
//       );
//
//       final cartItem2 = CartItemModel(
//         id: 'test-id-1',
//         product: product,
//         quantity: 2,
//       );
//
//       // Act
//       await cartRepository.addToCart(cartItem1);
//       await mockStorageService.updateCartItem(cartItem2);
//       final items = cartRepository.getCartItems();
//
//       // Assert
//       expect(items.length, 1);
//       expect(items.first.quantity, 2);
//     });
//
//     test('should remove item from cart', () async {
//       // Arrange
//       final product = ProductModel(
//         id: 1,
//         title: 'Test Product',
//         price: 99.99,
//         description: 'Test Description',
//         category: 'Test Category',
//         image: 'https://test.com/image.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final cartItem = CartItemModel(
//         id: 'test-id',
//         product: product,
//         quantity: 1,
//       );
//
//       // Act
//       await cartRepository.addToCart(cartItem);
//       await cartRepository.removeFromCart('test-id');
//       final items = cartRepository.getCartItems();
//
//       // Assert
//       expect(items.length, 0);
//     });
//
//     test('should calculate cart total correctly', () async {
//       // Arrange
//       final product1 = ProductModel(
//         id: 1,
//         title: 'Product 1',
//         price: 10.0,
//         description: 'Test',
//         category: 'Test',
//         image: 'test.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final product2 = ProductModel(
//         id: 2,
//         title: 'Product 2',
//         price: 20.0,
//         description: 'Test',
//         category: 'Test',
//         image: 'test.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final cartItem1 = CartItemModel(
//         id: 'id-1',
//         product: product1,
//         quantity: 2,
//       );
//
//       final cartItem2 = CartItemModel(
//         id: 'id-2',
//         product: product2,
//         quantity: 1,
//       );
//
//       // Act
//       await cartRepository.addToCart(cartItem1);
//       await cartRepository.addToCart(cartItem2);
//       final total = cartRepository.getCartTotal();
//
//       // Assert
//       expect(total, 40.0); // (10 * 2) + (20 * 1) = 40
//     });
//
//     test('should clear all items from cart', () async {
//       // Arrange
//       final product = ProductModel(
//         id: 1,
//         title: 'Test Product',
//         price: 99.99,
//         description: 'Test Description',
//         category: 'Test Category',
//         image: 'https://test.com/image.jpg',
//         rating: RatingModel(rate: 4.5, count: 100),
//       );
//
//       final cartItem = CartItemModel(
//         id: const Uuid().v4(),
//         product: product,
//         quantity: 1,
//       );
//
//       // Act
//       await cartRepository.addToCart(cartItem);
//       await cartRepository.clearCart();
//       final items = cartRepository.getCartItems();
//
//       // Assert
//       expect(items.length, 0);
//     });
//   });
// }
