/// Product entity for BNPL store
class ProductItem {
  final int id;
  final String name;
  final String company;  // Brand name (e.g., Samsung, Aarong)
  final String vendor;   // Shop/Vendor name where product is listed
  final String category;
  final String subCategory;
  final int price;
  final String? imageUrl;

  const ProductItem({
    required this.id,
    required this.name,
    required this.company,
    required this.vendor,
    required this.category,
    required this.subCategory,
    required this.price,
    this.imageUrl,
  });
}
