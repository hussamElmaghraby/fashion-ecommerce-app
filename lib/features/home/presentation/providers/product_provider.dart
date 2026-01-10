import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../../../data/models/product_model.dart';

// Products Provider
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getProducts();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getCategories();
});

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Filtered Products Provider
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return productsAsync.whenData((products) {
    var filtered = products;

    // Filter by category
    if (selectedCategory != null && selectedCategory.isNotEmpty) {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.category.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  });
});

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Product Details Provider
final productDetailsProvider = FutureProvider.family<ProductModel, int>((ref, id) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getProductById(id);
});
