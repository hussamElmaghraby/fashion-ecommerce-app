import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<ProductModel>> getProducts() async {
    return await _apiService.getProducts();
  }

  Future<ProductModel> getProductById(int id) async {
    return await _apiService.getProductById(id);
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    return await _apiService.getProductsByCategory(category);
  }

  Future<List<String>> getCategories() async {
    return await _apiService.getCategories();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await _apiService.getProducts();
    return products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
