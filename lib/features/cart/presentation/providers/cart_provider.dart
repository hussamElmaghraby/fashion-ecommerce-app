import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../../../data/models/cart_item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(cartRepositoryProvider));
});

class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get shipping => 0.0; // Free shipping or calculated at checkout
  double get tax => subtotal * 0.05; // 5% VAT
  double get total => subtotal + shipping + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final dynamic _cartRepository;

  CartNotifier(this._cartRepository) : super(CartState()) {
    _loadCartItems();
  }

  void _loadCartItems() {
    final items = _cartRepository.getCartItems();
    state = state.copyWith(items: items);
  }

  Future<void> addToCart(CartItemModel item) async {
    state = state.copyWith(isLoading: true);

    try {
      await _cartRepository.addToCart(item);
      _loadCartItems();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> removeFromCart(String itemId) async {
    state = state.copyWith(isLoading: true);

    try {
      await _cartRepository.removeFromCart(itemId);
      _loadCartItems();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _cartRepository.updateCartItemQuantity(itemId, quantity);
      _loadCartItems();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true);

    try {
      await _cartRepository.clearCart();
      state = CartState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
