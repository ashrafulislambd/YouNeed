import '../../entities/product_item.dart';

/// Interface for product repository - abstracts data source
abstract class IProductItemRepository {
  Future<List<ProductItem>> getProducts();
  Future<List<ProductItem>> getProductsByCategory(String category);
  Future<List<ProductItem>> getProductsBySubCategory(String category, String subCategory);
  Future<List<String>> getCategories();
  Future<List<String>> getSubCategories(String category);
}
