import '../models/cart_item_model.dart';
import '../services/storage_service.dart';

class CartRepository {
  final StorageService _storageService;

  CartRepository(this._storageService);

  Future<void> addToCart(CartItemModel item) async {
    // Check if item already exists
    final existingItems = _storageService.getCartItems();
    final existingItem = existingItems.where((i) =>
        i.product.id == item.product.id &&
        i.selectedSize == item.selectedSize &&
        i.selectedColor == item.selectedColor).firstOrNull;

    if (existingItem != null) {
      // Update quantity
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      await _storageService.updateCartItem(updatedItem);
    } else {
      await _storageService.addToCart(item);
    }
  }

  Future<void> removeFromCart(String itemId) async {
    await _storageService.removeFromCart(itemId);
  }

  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    final items = _storageService.getCartItems();
    final item = items.firstWhere((i) => i.id == itemId);
    final updatedItem = item.copyWith(quantity: quantity);
    await _storageService.updateCartItem(updatedItem);
  }

  Future<void> clearCart() async {
    await _storageService.clearCart();
  }

  List<CartItemModel> getCartItems() {
    return _storageService.getCartItems();
  }

  double getCartTotal() {
    final items = _storageService.getCartItems();
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int getCartItemCount() {
    final items = _storageService.getCartItems();
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
