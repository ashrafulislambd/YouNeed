import 'package:flutter/material.dart';
import 'package:dashboard/bnpl/bnpl_plans_screen.dart';
import 'package:dashboard/storefront/application/interfaces/product_item_repository.dart';
import 'package:dashboard/storefront/entities/product_item.dart';
import '../theme_provider.dart';

/// Categorized Product List Screen with navigation and BNPL checkout
/// Uses dependency injection for product repository - follows clean architecture
class ProductListScreen extends StatefulWidget {
  final IProductItemRepository productRepository;

  const ProductListScreen({
    super.key,
    required this.productRepository,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductItem> _allProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _selectedSubCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final products = await widget.productRepository.getProducts();
      final categories = await widget.productRepository.getCategories();
      setState(() {
        _allProducts = products;
        _categories = ['All', ...categories];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<String> get subCategories {
    if (_selectedCategory == 'All') return ['All'];
    final subs = _allProducts
        .where((p) => p.category == _selectedCategory)
        .map((p) => p.subCategory)
        .toSet()
        .toList();
    return ['All', ...subs];
  }

  List<ProductItem> get filteredProducts {
    return _allProducts.where((p) {
      if (_selectedCategory != 'All' && p.category != _selectedCategory) return false;
      if (_selectedSubCategory != 'All' && p.subCategory != _selectedSubCategory) return false;
      return true;
    }).toList();
  }

  void _goToCheckout(ProductItem product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BnplPlansScreen(
          cartTotal: product.price,
          cartItems: {product.id: 1},
          onPlanSelected: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} purchased with BNPL!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_basket;
      case 'Fashion':
        return Icons.checkroom;
      case 'Electronics':
        return Icons.devices;
      case 'Furniture':
        return Icons.chair;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Groceries':
        return Colors.green;
      case 'Fashion':
        return Colors.pink;
      case 'Electronics':
        return Colors.blue;
      case 'Furniture':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getPlanBadge(int price) {
    if (price <= 5000) return 'Plan A';
    if (price <= 15000) return 'Plan B';
    if (price <= 40000) return 'Plan C';
    return 'Plan D';
  }

  Color _getPlanColor(int price) {
    if (price <= 5000) return const Color(0xFF4CAF50); // Green
    if (price <= 15000) return const Color(0xFFFFC107); // Yellow
    if (price <= 40000) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.orange),
            tooltip: 'Transactions',
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
          IconButton(
            icon: const Icon(Icons.credit_card, color: Colors.blueAccent),
            tooltip: 'Credit Status',
            onPressed: () => Navigator.pushNamed(context, '/credit'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.green),
            tooltip: 'Due Payments',
            onPressed: () => Navigator.pushNamed(context, '/due-payment'),
          ),
          IconButton(
            icon: const Icon(Icons.verified_user_outlined, color: Colors.purple),
            tooltip: 'KYC',
            onPressed: () => Navigator.pushNamed(context, '/kyc'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.deepPurple),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category Filter Chips
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Categories
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (cat != 'All')
                                      Icon(
                                        _getCategoryIcon(cat),
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : _getCategoryColor(cat),
                                      ),
                                    if (cat != 'All') const SizedBox(width: 6),
                                    Text(cat),
                                  ],
                                ),
                                selectedColor: cat == 'All'
                                    ? Colors.deepPurple
                                    : _getCategoryColor(cat),
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : null,
                                  fontWeight: isSelected ? FontWeight.bold : null,
                                ),
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = cat;
                                    _selectedSubCategory = 'All';
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Sub Categories (if a main category is selected)
                      if (_selectedCategory != 'All') ...[
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: subCategories.map((sub) {
                              final isSelected = _selectedSubCategory == sub;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  selected: isSelected,
                                  label: Text(sub),
                                  selectedColor: _getCategoryColor(_selectedCategory)
                                      .withOpacity(0.7),
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : null,
                                    fontSize: 12,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedSubCategory = sub;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Product Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredProducts.length} products',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _selectedCategory == 'All'
                            ? 'All Categories'
                            : _selectedSubCategory == 'All'
                                ? _selectedCategory
                                : '$_selectedCategory > $_selectedSubCategory',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Product List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _ProductCard(
                        product: filteredProducts[index],
                        onAddToCart: () => _goToCheckout(filteredProducts[index]),
                        getPlanBadge: _getPlanBadge,
                        getPlanColor: _getPlanColor,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final ProductItem product;
  final VoidCallback onAddToCart;
  final String Function(int) getPlanBadge;
  final Color Function(int) getPlanColor;

  const _ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.getPlanBadge,
    required this.getPlanColor,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final planColor = widget.getPlanColor(p.price);

    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey[500]! : Colors.grey[600]!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shadowColor: Theme.of(context).shadowColor,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: _isHovered
                ? BorderSide(color: planColor.withOpacity(0.4), width: 1.5)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Icon/Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: planColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getProductIcon(p.category),
                    size: 28,
                    color: planColor,
                  ),
                ),
                const SizedBox(width: 14),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        p.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Brand/Company Name
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 11,
                            color: subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p.company,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Vendor/Shop Name
                      Row(
                        children: [
                          Icon(
                            Icons.storefront,
                            size: 11,
                            color: Colors.teal.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              p.vendor,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.subCategory,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Price & Action Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Plan Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: planColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: planColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        widget.getPlanBadge(p.price),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: planColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Text(
                      'Tk ${p.price}',
                      style: TextStyle(
                        color: planColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: isDark
                            ? [Shadow(color: planColor.withOpacity(0.3), blurRadius: 6)]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add to Cart Button
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: widget.onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: planColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getProductIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.local_grocery_store;
      case 'Fashion':
        return Icons.checkroom;
      case 'Electronics':
        return Icons.devices;
      case 'Furniture':
        return Icons.weekend;
      default:
        return Icons.inventory_2;
    }
  }
}
