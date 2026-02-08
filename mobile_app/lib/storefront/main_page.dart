import 'dart:convert';
import 'package:dashboard/storefront/application/dto/order_dto.dart';
import 'package:dashboard/storefront/application/interfaces/order_repository.dart';
import 'package:dashboard/storefront/application/interfaces/product_repository.dart';
import 'package:dashboard/storefront/entities/product.dart';
import 'package:dashboard/storefront/entities/user_context.dart';
import 'package:dashboard/bnpl/bnpl_plans_screen.dart';
import 'package:flutter/material.dart';

class ShopMainPage extends StatefulWidget {
  final IProductRepository productRepository;
  final IOrderRepository orderRepository;

  const ShopMainPage({
    super.key,
    required this.productRepository,
    required this.orderRepository,
  });

  @override
  State<ShopMainPage> createState() => _ShopMainPageState();
}

class _ShopMainPageState extends State<ShopMainPage> {
  List<Product> _products = [];
  Map<int, int> _cartItems = {}; // Product ID -> Quantity
  bool _isLoading = true;
  bool _isOrdering = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await widget.productRepository.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error cleanly
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addToCart(int productId) {
    setState(() {
      _cartItems[productId] = (_cartItems[productId] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(milliseconds: 600),
      ),
    );
  }

  void _removeFromCart(int productId) {
    setState(() {
      if ((_cartItems[productId] ?? 0) > 1) {
        _cartItems[productId] = _cartItems[productId]! - 1;
      } else {
        _cartItems.remove(productId);
      }
    });
  }

  int get _cartItemCount {
    return _cartItems.values.fold(0, (sum, qty) => sum + qty);
  }

  int get _cartTotalPrice {
    int total = 0;
    _cartItems.forEach((pid, qty) {
      final product = _products.firstWhere(
        (p) => p.id == pid,
        orElse: () => Product("", "", 0, 0, ""),
      );
      total += (product.price ?? 0) * qty;
    });
    return total;
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Your Cart",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _cartItems.isEmpty
                        ? const Center(child: Text("Cart is empty"))
                        : ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final pid = _cartItems.keys.elementAt(index);
                              final qty = _cartItems[pid]!;
                              final product = _products.firstWhere(
                                (p) => p.id == pid,
                              );

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: product.image != null
                                      ? Image.memory(
                                          base64Decode(product.image!),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image, size: 50),
                                  title: Text(product.title ?? "Unknown"),
                                  subtitle: Text("\$${product.price} x $qty"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: () {
                                          setState(() => _removeFromCart(pid));
                                          setSheetState(() {}); // Update sheet
                                        },
                                      ),
                                      Text(
                                        "$qty",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () {
                                          setState(() => _addToCart(pid));
                                          setSheetState(() {}); // Update sheet
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "\$${_cartTotalPrice}",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Original Checkout Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _cartItems.isEmpty || _isOrdering
                                ? null
                                : () {
                                    Navigator.pop(context); // Close cart
                                    _processOrder();
                                  },
                            child: const Text("Pay Now"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // BNPL Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _cartItems.isEmpty || _isOrdering
                                ? null
                                : () {
                                    Navigator.pop(context); // Close cart
                                    _navigateToBnplPlans();
                                  },
                            child: const Text("Pay Later"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToBnplPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BnplPlansScreen(
          cartTotal: _cartTotalPrice,
          cartItems: Map.from(_cartItems),
          onPlanSelected: () {
            // Clear cart after BNPL plan is selected
            setState(() {
              _cartItems.clear();
            });
          },
        ),
      ),
    );
  }

  Future<void> _processOrder() async {
    setState(() {
      _isOrdering = true;
    });

    final orderDto = OrderDTO();
    orderDto.quantities = _cartItems;
    orderDto.userContext = UserContext(); // Dummy user context

    try {
      final response = await widget.orderRepository.makeOrder(orderDto);

      if (mounted) {
        setState(() {
          _isOrdering = false;
        });

        if (response.successful == true) {
          setState(() {
            _cartItems.clear();
          });
          _showOrderDialog(
            "Success",
            "Order placed successfully! ID: ${response.orderId}",
            true,
          );
        } else {
          _showOrderDialog(
            "Failed",
            response.errorMessage ?? "Unknown error",
            false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isOrdering = false;
        });
        _showOrderDialog("Error", e.toString(), false);
      }
    }
  }

  void _showOrderDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCart,
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: product.image != null
                                ? Image.memory(
                                    base64Decode(product.image!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title ?? "No Title",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () => _addToCart(product.id!),
                                    child: const Text("Add"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_isOrdering)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
    );
  }
}
