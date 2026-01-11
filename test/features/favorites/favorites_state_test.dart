import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

void main() {
  group('FavoritesState', () {
    test('initial state has empty favorites', () {
      final state = FavoritesState(favoriteIds: []);

      expect(state.favoriteIds, isEmpty);
      expect(state.isLoading, false);
    });

    test('state with favorite ids', () {
      final state = FavoritesState(favoriteIds: [1, 2, 3]);

      expect(state.favoriteIds.length, 3);
      expect(state.favoriteIds.contains(2), true);
    });

    test('copyWith updates favoriteIds', () {
      final state = FavoritesState(favoriteIds: [1]);
      final updated = state.copyWith(favoriteIds: [1, 2, 3]);

      expect(updated.favoriteIds.length, 3);
      expect(state.favoriteIds.length, 1);
    });

    test('copyWith updates isLoading', () {
      final state = FavoritesState(favoriteIds: []);
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
      expect(state.isLoading, false);
    });

    test('copyWith preserves values when not specified', () {
      final state = FavoritesState(favoriteIds: [1, 2], isLoading: true);
      final updated = state.copyWith(favoriteIds: [1, 2, 3]);

      expect(updated.isLoading, true);
    });
  });

  group('getFavoriteProducts logic', () {
    List<ProductModel> createProducts() {
      return [
        ProductModel(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 4.0, count: 10),
        ),
        ProductModel(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 4.5, count: 20),
        ),
        ProductModel(
          id: 3,
          title: 'Product 3',
          price: 30.0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 4.2, count: 15),
        ),
      ];
    }

    test('filters products by favorite ids', () {
      final products = createProducts();
      final favoriteIds = [1, 3];

      final favorites = products
          .where((p) => favoriteIds.contains(p.id))
          .toList();

      expect(favorites.length, 2);
      expect(favorites.any((p) => p.id == 2), false);
    });

    test('returns empty when no favorites', () {
      final products = createProducts();
      final favoriteIds = <int>[];

      final favorites = products
          .where((p) => favoriteIds.contains(p.id))
          .toList();

      expect(favorites, isEmpty);
    });

    test('returns empty when favorite ids not in products', () {
      final products = createProducts();
      final favoriteIds = [99, 100];

      final favorites = products
          .where((p) => favoriteIds.contains(p.id))
          .toList();

      expect(favorites, isEmpty);
    });

    test('returns all when all are favorites', () {
      final products = createProducts();
      final favoriteIds = [1, 2, 3];

      final favorites = products
          .where((p) => favoriteIds.contains(p.id))
          .toList();

      expect(favorites.length, 3);
    });
  });

  group('isFavorite check', () {
    test('returns true when id in favorites', () {
      final favoriteIds = [1, 2, 3];

      expect(favoriteIds.contains(2), true);
    });

    test('returns false when id not in favorites', () {
      final favoriteIds = [1, 2, 3];

      expect(favoriteIds.contains(5), false);
    });

    test('returns false for empty favorites', () {
      final favoriteIds = <int>[];

      expect(favoriteIds.contains(1), false);
    });
  });

  group('toggle favorite logic', () {
    test('adds product to favorites', () {
      final favoriteIds = <int>[1, 2];
      final productId = 3;

      if (!favoriteIds.contains(productId)) {
        favoriteIds.add(productId);
      }

      expect(favoriteIds.contains(3), true);
      expect(favoriteIds.length, 3);
    });

    test('removes product from favorites', () {
      final favoriteIds = <int>[1, 2, 3];
      final productId = 2;

      if (favoriteIds.contains(productId)) {
        favoriteIds.remove(productId);
      }

      expect(favoriteIds.contains(2), false);
      expect(favoriteIds.length, 2);
    });

    test('does not duplicate when adding existing', () {
      final favoriteIds = <int>[1, 2, 3];
      final productId = 2;

      if (!favoriteIds.contains(productId)) {
        favoriteIds.add(productId);
      }

      expect(favoriteIds.length, 3);
    });
  });
}
