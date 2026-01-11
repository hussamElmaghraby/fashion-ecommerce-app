import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

void main() {
  List<ProductModel> createTestProducts() {
    return [
      ProductModel(
        id: 1,
        title: 'Mens Cotton Jacket',
        price: 55.99,
        description: 'Great outerwear jackets for Spring',
        category: "men's clothing",
        image: 'jacket.jpg',
        rating: RatingModel(rate: 4.7, count: 500),
      ),
      ProductModel(
        id: 2,
        title: 'Womens Dress',
        price: 109.95,
        description: 'Perfect for casual wear',
        category: "women's clothing",
        image: 'dress.jpg',
        rating: RatingModel(rate: 4.5, count: 146),
      ),
      ProductModel(
        id: 3,
        title: 'Gold Petite Bracelet',
        price: 695.0,
        description: 'Clarity and color. 18K yellow gold.',
        category: 'jewelery',
        image: 'bracelet.jpg',
        rating: RatingModel(rate: 4.6, count: 400),
      ),
      ProductModel(
        id: 4,
        title: 'Hard Drive SSD',
        price: 109.0,
        description: 'Storage hard drive for data',
        category: 'electronics',
        image: 'ssd.jpg',
        rating: RatingModel(rate: 4.8, count: 319),
      ),
      ProductModel(
        id: 5,
        title: 'Mens Casual Slim Fit',
        price: 22.3,
        description: 'Slim fit with premium fabric',
        category: "men's clothing",
        image: 'shirt.jpg',
        rating: RatingModel(rate: 4.1, count: 259),
      ),
    ];
  }

  group('Filter by category', () {
    test('filters mens clothing', () {
      final products = createTestProducts();
      final filtered = products
          .where((p) => p.category == "men's clothing")
          .toList();

      expect(filtered.length, 2);
      expect(filtered.every((p) => p.category == "men's clothing"), true);
    });

    test('filters womens clothing', () {
      final products = createTestProducts();
      final filtered = products
          .where((p) => p.category == "women's clothing")
          .toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Womens Dress');
    });

    test('returns all when no category selected', () {
      final products = createTestProducts();
      String? selectedCategory;

      final filtered = selectedCategory != null
          ? products.where((p) => p.category == selectedCategory).toList()
          : products;

      expect(filtered.length, 5);
    });

    test('returns empty for non-existent category', () {
      final products = createTestProducts();
      final filtered = products.where((p) => p.category == 'shoes').toList();

      expect(filtered, isEmpty);
    });
  });

  group('Filter by search query', () {
    test('finds products by title keyword', () {
      final products = createTestProducts();
      final query = 'jacket';

      final filtered = products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      expect(filtered.length, 1);
    });

    test('finds products by description keyword', () {
      final products = createTestProducts();
      final query = 'spring';

      final filtered = products
          .where(
            (p) => p.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Mens Cotton Jacket');
    });

    test('finds products by category keyword', () {
      final products = createTestProducts();
      final query = 'electronics';

      final filtered = products
          .where((p) => p.category.toLowerCase().contains(query.toLowerCase()))
          .toList();

      expect(filtered.length, 1);
    });

    test('search is case insensitive', () {
      final products = createTestProducts();
      final query = 'JACKET';

      final filtered = products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      expect(filtered.length, 1);
    });

    test('empty query returns all products', () {
      final products = createTestProducts();
      final query = '';

      final filtered = query.isEmpty
          ? products
          : products
                .where(
                  (p) => p.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

      expect(filtered.length, 5);
    });

    test('no matches returns empty list', () {
      final products = createTestProducts();
      final query = 'xyzabc123';

      final filtered = products
          .where(
            (p) =>
                p.title.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase()) ||
                p.category.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      expect(filtered, isEmpty);
    });
  });

  group('Combined category and search filter', () {
    test('filters by both category and search', () {
      final products = createTestProducts();
      final category = "men's clothing";
      final query = 'cotton';

      var filtered = products.where((p) => p.category == category).toList();
      filtered = filtered
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Mens Cotton Jacket');
    });

    test('returns empty when no products match both filters', () {
      final products = createTestProducts();
      final category = "men's clothing";
      final query = 'gold';

      var filtered = products.where((p) => p.category == category).toList();
      filtered = filtered
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      expect(filtered, isEmpty);
    });
  });

  group('Sort products', () {
    test('sorts by price ascending', () {
      final products = createTestProducts();
      products.sort((a, b) => a.price.compareTo(b.price));

      expect(products.first.title, 'Mens Casual Slim Fit');
      expect(products.last.title, 'Gold Petite Bracelet');
    });

    test('sorts by price descending', () {
      final products = createTestProducts();
      products.sort((a, b) => b.price.compareTo(a.price));

      expect(products.first.title, 'Gold Petite Bracelet');
      expect(products.last.title, 'Mens Casual Slim Fit');
    });

    test('sorts by rating descending', () {
      final products = createTestProducts();
      products.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));

      expect(products.first.title, 'Hard Drive SSD');
    });

    test('sorts by title alphabetically', () {
      final products = createTestProducts();
      products.sort((a, b) => a.title.compareTo(b.title));

      expect(products.first.title, 'Gold Petite Bracelet');
    });
  });

  group('Product statistics', () {
    test('calculates average rating', () {
      final products = createTestProducts();
      final avgRating =
          products.map((p) => p.rating.rate).reduce((a, b) => a + b) /
          products.length;

      expect(avgRating, closeTo(4.54, 0.01));
    });

    test('finds price range', () {
      final products = createTestProducts();
      final minPrice = products
          .map((p) => p.price)
          .reduce((a, b) => a < b ? a : b);
      final maxPrice = products
          .map((p) => p.price)
          .reduce((a, b) => a > b ? a : b);

      expect(minPrice, 22.3);
      expect(maxPrice, 695.0);
    });

    test('counts products by category', () {
      final products = createTestProducts();
      final categories = <String, int>{};

      for (var product in products) {
        categories[product.category] = (categories[product.category] ?? 0) + 1;
      }

      expect(categories["men's clothing"], 2);
      expect(categories['electronics'], 1);
    });
  });
}
