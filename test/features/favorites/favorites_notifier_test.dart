import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:fashion_ecommerce/data/services/storage_service.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  group('FavoritesNotifier initialization', () {
    test('loads favorites on creation', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.state.favoriteIds.length, 3);
      verify(() => mockStorage.getFavoriteIds()).called(1);
    });

    test('starts with empty favorites when none saved', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([]);

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.state.favoriteIds, isEmpty);
    });
  });

  group('FavoritesNotifier.toggleFavorite', () {
    test('adds product when not in favorites', () async {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2]);
      when(() => mockStorage.addFavorite(3)).thenAnswer((_) async {});

      final notifier = FavoritesNotifier(mockStorage);

      await notifier.toggleFavorite(3);

      expect(notifier.state.favoriteIds.contains(3), true);
      verify(() => mockStorage.addFavorite(3)).called(1);
    });

    test('removes product when in favorites', () async {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);
      when(() => mockStorage.removeFavorite(2)).thenAnswer((_) async {});

      final notifier = FavoritesNotifier(mockStorage);

      await notifier.toggleFavorite(2);

      expect(notifier.state.favoriteIds.contains(2), false);
      verify(() => mockStorage.removeFavorite(2)).called(1);
    });
  });

  group('FavoritesNotifier.isFavorite', () {
    test('returns true when product is in favorites', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.isFavorite(2), true);
    });

    test('returns false when product is not in favorites', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.isFavorite(5), false);
    });

    test('returns false for empty favorites', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([]);

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.isFavorite(1), false);
    });
  });

  group('FavoritesNotifier.getFavoriteProducts', () {
    List<ProductModel> createProducts() {
      return [
        ProductModel(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          description: 'Desc 1',
          category: 'Cat',
          image: 'img1.jpg',
          rating: RatingModel(rate: 4.0, count: 10),
        ),
        ProductModel(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: 'Desc 2',
          category: 'Cat',
          image: 'img2.jpg',
          rating: RatingModel(rate: 4.5, count: 20),
        ),
        ProductModel(
          id: 3,
          title: 'Product 3',
          price: 30.0,
          description: 'Desc 3',
          category: 'Cat',
          image: 'img3.jpg',
          rating: RatingModel(rate: 4.2, count: 15),
        ),
      ];
    }

    test('returns only favorite products', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 3]);

      final notifier = FavoritesNotifier(mockStorage);
      final products = createProducts();
      final favorites = notifier.getFavoriteProducts(products);

      expect(favorites.length, 2);
      expect(favorites.any((p) => p.id == 1), true);
      expect(favorites.any((p) => p.id == 3), true);
      expect(favorites.any((p) => p.id == 2), false);
    });

    test('returns empty when no favorites', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([]);

      final notifier = FavoritesNotifier(mockStorage);
      final products = createProducts();
      final favorites = notifier.getFavoriteProducts(products);

      expect(favorites, isEmpty);
    });

    test('returns empty when favorites not in product list', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([99, 100]);

      final notifier = FavoritesNotifier(mockStorage);
      final products = createProducts();
      final favorites = notifier.getFavoriteProducts(products);

      expect(favorites, isEmpty);
    });

    test('returns all when all products are favorites', () {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);

      final notifier = FavoritesNotifier(mockStorage);
      final products = createProducts();
      final favorites = notifier.getFavoriteProducts(products);

      expect(favorites.length, 3);
    });
  });

  group('FavoritesNotifier.clearAllFavorites', () {
    test('clears all favorites', () async {
      when(() => mockStorage.getFavoriteIds()).thenReturn([1, 2, 3]);
      when(() => mockStorage.clearFavorites()).thenAnswer((_) async {});

      final notifier = FavoritesNotifier(mockStorage);

      expect(notifier.state.favoriteIds.length, 3);

      await notifier.clearAllFavorites();

      expect(notifier.state.favoriteIds, isEmpty);
      verify(() => mockStorage.clearFavorites()).called(1);
    });
  });
}
