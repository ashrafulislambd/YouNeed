import '../application/interfaces/product_item_repository.dart';
import '../entities/product_item.dart';

/// Mock implementation of IProductItemRepository
/// Replace this with API implementation when backend is ready
class MockProductItemRepository implements IProductItemRepository {
  /// Mock products covering all BNPL schemes:
  /// Plan A: Up to Tk 5,000 (Groceries, essentials)
  /// Plan B: Up to Tk 15,000 (Clothes, accessories)
  /// Plan C: Up to Tk 40,000 (Phones, appliances)
  /// Plan D: Tk 25,000 - 80,000 (Laptop, furniture)
  /// 
  /// company = Brand name (manufacturer)
  /// vendor = Shop name (where customer buys from)
  static const List<ProductItem> _mockProducts = [
    // GROCERIES & ESSENTIALS (Plan A: Up to Tk 5,000)
    ProductItem(id: 1, name: 'Fresh Milk 1L', company: 'Aarong Dairy', vendor: 'Shwapno Uttara', category: 'Groceries', subCategory: 'Dairy', price: 120),
    ProductItem(id: 2, name: 'Butter 200g', company: 'Pran Foods', vendor: 'Meena Bazar Gulshan', category: 'Groceries', subCategory: 'Dairy', price: 280),
    ProductItem(id: 3, name: 'Cheese Block 500g', company: 'Aarong Dairy', vendor: 'Agora Dhanmondi', category: 'Groceries', subCategory: 'Dairy', price: 650),
    ProductItem(id: 4, name: 'Rice 5kg Premium', company: 'ACI Foods', vendor: 'Unimart Banani', category: 'Groceries', subCategory: 'Staples', price: 850),
    ProductItem(id: 5, name: 'Cooking Oil 5L', company: 'Rupchanda', vendor: 'Shwapno Mirpur', category: 'Groceries', subCategory: 'Staples', price: 1200),
    ProductItem(id: 6, name: 'Sugar 2kg', company: 'Dhaka Sugar', vendor: 'Agora Mohammadpur', category: 'Groceries', subCategory: 'Staples', price: 280),
    ProductItem(id: 7, name: 'Detergent 2kg', company: 'Wheel', vendor: 'Meena Bazar Uttara', category: 'Groceries', subCategory: 'Cleaning', price: 450),
    ProductItem(id: 8, name: 'Shampoo 400ml', company: 'Sunsilk', vendor: 'Unimart Bashundhara', category: 'Groceries', subCategory: 'Personal Care', price: 380),
    ProductItem(id: 9, name: 'Monthly Grocery Bundle', company: 'Chaldal', vendor: 'Chaldal Online', category: 'Groceries', subCategory: 'Bundles', price: 4500),
    
    // CLOTHES & ACCESSORIES (Plan B: Up to Tk 15,000)
    ProductItem(id: 10, name: 'Cotton T-Shirt', company: 'Yellow', vendor: 'Yellow Jamuna Future', category: 'Fashion', subCategory: 'Mens Wear', price: 1200),
    ProductItem(id: 11, name: 'Formal Shirt', company: 'Aarong', vendor: 'Aarong Gulshan', category: 'Fashion', subCategory: 'Mens Wear', price: 2800),
    ProductItem(id: 12, name: 'Denim Jeans', company: 'Richman', vendor: 'Bashundhara City', category: 'Fashion', subCategory: 'Mens Wear', price: 3500),
    ProductItem(id: 13, name: 'Saree Silk', company: 'Aarong', vendor: 'Aarong Dhanmondi', category: 'Fashion', subCategory: 'Womens Wear', price: 8500),
    ProductItem(id: 14, name: 'Kurti Designer', company: 'Rang Bangladesh', vendor: 'Rang Uttara', category: 'Fashion', subCategory: 'Womens Wear', price: 2200),
    ProductItem(id: 15, name: 'Leather Wallet', company: 'Apex', vendor: 'Apex Jamuna Future', category: 'Fashion', subCategory: 'Accessories', price: 1800),
    ProductItem(id: 16, name: 'Wrist Watch', company: 'Fastrack', vendor: 'Titan Eye Gulshan', category: 'Fashion', subCategory: 'Accessories', price: 4500),
    ProductItem(id: 17, name: 'Leather Belt', company: 'Bata', vendor: 'Bata Bashundhara', category: 'Fashion', subCategory: 'Accessories', price: 950),
    ProductItem(id: 18, name: 'Sunglasses Premium', company: 'Ray-Ban', vendor: 'Lenskart Banani', category: 'Fashion', subCategory: 'Accessories', price: 12000),
    
    // PHONES & APPLIANCES (Plan C: Up to Tk 40,000)
    ProductItem(id: 19, name: 'Smartphone Budget', company: 'Realme', vendor: 'Samsung Smartzone Uttara', category: 'Electronics', subCategory: 'Phones', price: 15000),
    ProductItem(id: 20, name: 'Smartphone Mid-Range', company: 'Samsung', vendor: 'Pickaboo Online', category: 'Electronics', subCategory: 'Phones', price: 28000),
    ProductItem(id: 21, name: 'Smartphone Premium', company: 'Xiaomi', vendor: 'Daraz Official', category: 'Electronics', subCategory: 'Phones', price: 38000),
    ProductItem(id: 22, name: 'Air Conditioner 1 Ton', company: 'Walton', vendor: 'Walton Plaza Mirpur', category: 'Electronics', subCategory: 'Appliances', price: 35000),
    ProductItem(id: 23, name: 'Refrigerator 250L', company: 'Samsung', vendor: 'Rangs Electronics', category: 'Electronics', subCategory: 'Appliances', price: 32000),
    ProductItem(id: 24, name: 'Washing Machine', company: 'LG', vendor: 'Transcom Digital', category: 'Electronics', subCategory: 'Appliances', price: 28000),
    ProductItem(id: 25, name: 'Microwave Oven', company: 'Panasonic', vendor: 'Best Electronics', category: 'Electronics', subCategory: 'Appliances', price: 12000),
    ProductItem(id: 26, name: 'LED TV 32"', company: 'Walton', vendor: 'Walton Plaza Uttara', category: 'Electronics', subCategory: 'TV & Audio', price: 22000),
    ProductItem(id: 27, name: 'Bluetooth Speaker', company: 'JBL', vendor: 'Gadget & Gear', category: 'Electronics', subCategory: 'TV & Audio', price: 8500),
    
    // LAPTOPS & FURNITURE (Plan D: Tk 25,000 - 80,000)
    ProductItem(id: 28, name: 'Laptop Entry Level', company: 'HP', vendor: 'Computer Village IDB', category: 'Electronics', subCategory: 'Laptops', price: 45000),
    ProductItem(id: 29, name: 'Laptop Gaming', company: 'Asus', vendor: 'Ryans Computers', category: 'Electronics', subCategory: 'Laptops', price: 75000),
    ProductItem(id: 30, name: 'Laptop Business', company: 'Lenovo', vendor: 'Star Tech BD', category: 'Electronics', subCategory: 'Laptops', price: 65000),
    ProductItem(id: 31, name: 'Monitor 24" IPS', company: 'Dell', vendor: 'UCC Bangladesh', category: 'Electronics', subCategory: 'Monitors', price: 28000),
    ProductItem(id: 32, name: 'Monitor 27" 144Hz', company: 'Asus', vendor: 'Techland BD', category: 'Electronics', subCategory: 'Monitors', price: 42000),
    ProductItem(id: 33, name: 'Sofa Set 3+2', company: 'Hatil', vendor: 'Hatil Uttara Showroom', category: 'Furniture', subCategory: 'Living Room', price: 55000),
    ProductItem(id: 34, name: 'Dining Table 6 Seater', company: 'Otobi', vendor: 'Otobi Gulshan', category: 'Furniture', subCategory: 'Dining', price: 48000),
    ProductItem(id: 35, name: 'Bed King Size', company: 'Hatil', vendor: 'Hatil Dhanmondi', category: 'Furniture', subCategory: 'Bedroom', price: 62000),
    ProductItem(id: 36, name: 'Office Desk Set', company: 'Otobi', vendor: 'Otobi Bashundhara', category: 'Furniture', subCategory: 'Office', price: 35000),
    ProductItem(id: 37, name: 'Wardrobe 3 Door', company: 'Hatil', vendor: 'Hatil Mirpur Showroom', category: 'Furniture', subCategory: 'Bedroom', price: 45000),
  ];

  @override
  Future<List<ProductItem>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts;
  }

  @override
  Future<List<ProductItem>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProducts.where((p) => p.category == category).toList();
  }

  @override
  Future<List<ProductItem>> getProductsBySubCategory(String category, String subCategory) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProducts
        .where((p) => p.category == category && p.subCategory == subCategory)
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProducts.map((p) => p.category).toSet().toList();
  }

  @override
  Future<List<String>> getSubCategories(String category) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProducts
        .where((p) => p.category == category)
        .map((p) => p.subCategory)
        .toSet()
        .toList();
  }
}
