import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/services/storage_service.dart';

// Favorites state
class FavoritesState {
  final List<int> favoriteIds;
  final bool isLoading;

  FavoritesState({
    required this.favoriteIds,
    this.isLoading = false,
  });

  FavoritesState copyWith({
    List<int>? favoriteIds,
    bool? isLoading,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Favorites notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final StorageService _storageService;

  FavoritesNotifier(this._storageService)
      : super(FavoritesState(favoriteIds: [])) {
    _loadFavorites();
  }

  // Load favorites from storage
  void _loadFavorites() {
    final favorites = _storageService.getFavoriteIds();
    state = state.copyWith(favoriteIds: favorites);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int productId) async {
    final currentFavorites = List<int>.from(state.favoriteIds);
    
    if (currentFavorites.contains(productId)) {
      // Remove from favorites
      currentFavorites.remove(productId);
      await _storageService.removeFavorite(productId);
    } else {
      // Add to favorites
      currentFavorites.add(productId);
      await _storageService.addFavorite(productId);
    }

    state = state.copyWith(favoriteIds: currentFavorites);
  }

  // Check if product is favorite
  bool isFavorite(int productId) {
    return state.favoriteIds.contains(productId);
  }

  // Get favorite products from all products
  List<ProductModel> getFavoriteProducts(List<ProductModel> allProducts) {
    return allProducts
        .where((product) => state.favoriteIds.contains(product.id))
        .toList();
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _storageService.clearFavorites();
    state = state.copyWith(favoriteIds: []);
  }
}

// Provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(StorageService());
});
