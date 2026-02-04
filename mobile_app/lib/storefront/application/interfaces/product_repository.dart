import 'package:dashboard/storefront/entities/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts();

  Future<Product> getProductById(int id);
}
