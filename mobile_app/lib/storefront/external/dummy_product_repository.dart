import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dashboard/storefront/application/interfaces/product_repository.dart';
import 'package:dashboard/storefront/entities/product.dart';

class DummyProductRepository implements IProductRepository {
  List<Product>? _cachedProducts;

  @override
  Future<Product> getProductById(int id) async {
    return _cachedProducts!.firstWhere((product) => product.id == id);
  }

  @override
  Future<List<Product>> getProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    // Using dummyjson.com as it is very reliable for API usage
    final productData = [
      _ProductData(
        name: "Laptop",
        desc: "High performance gaming laptop",
        price: 120000,
        id: 1,
        // Red
        imageUrl:
            "https://dummyjson.com/image/300x300/ff0000/ffffff?text=Laptop",
      ),
      _ProductData(
        name: "Smartphone",
        desc: "Android flagship phone",
        price: 45000,
        id: 2,
        // Green
        imageUrl:
            "https://dummyjson.com/image/300x300/008000/ffffff?text=Phone",
      ),
      _ProductData(
        name: "Headphones",
        desc: "Noise cancelling headphones",
        price: 8500,
        id: 3,
        // Blue
        imageUrl:
            "https://dummyjson.com/image/300x300/0000ff/ffffff?text=Audio",
      ),
      _ProductData(
        name: "Smart Watch",
        desc: "Fitness tracking smartwatch",
        price: 12000,
        id: 4,
        // Yellow
        imageUrl:
            "https://dummyjson.com/image/300x300/eebb00/000000?text=Watch",
      ),
      _ProductData(
        name: "Keyboard",
        desc: "Mechanical RGB keyboard",
        price: 6500,
        id: 5,
        // Purple
        imageUrl: "https://dummyjson.com/image/300x300/800080/ffffff?text=Keys",
      ),
      _ProductData(
        name: "Mouse",
        desc: "Wireless gaming mouse",
        price: 4200,
        id: 6,
        // Orange
        imageUrl:
            "https://dummyjson.com/image/300x300/ffa500/000000?text=Mouse",
      ),
    ];

    final futureProducts = productData.map((data) async {
      final base64Image = await _fetchAndConvertImage(data.imageUrl);
      final product = Product(
        data.name,
        data.desc,
        data.price,
        1,
        base64Image,
      ); // Used 1 as dummy categoryId
      product.id = data.id;
      return product;
    });

    _cachedProducts = await Future.wait(futureProducts);
    return _cachedProducts!;
  }

  Future<String> _fetchAndConvertImage(String url) async {
    try {
      // 1. We MUST add a User-Agent to mimic a browser,
      // otherwise some servers return 403 Forbidden (HTML) which crashes the decoder.
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // 2. SAFETY CHECK: Check if bytes are actually an image.
        // If the first bytes look like "<!DOCTYPE" or "<html>", it's an error page.
        if (bytes.length > 4) {
          // Simple check for text/html content in the first few bytes
          // (ASCII '<' is 60). If it starts with '<', it's likely HTML, not an image.
          if (bytes[0] == 60) {
            print("ERROR: URL returned HTML instead of Image: $url");
            return _fallbackBase64;
          }
        }

        return base64Encode(bytes);
      } else {
        print("HTTP Error ${response.statusCode} for: $url");
        return _fallbackBase64;
      }
    } catch (e) {
      print("Network Exception for $url: $e");
      return _fallbackBase64;
    }
  }

  // A safe 1x1 transparent PNG to return if fetching fails
  static const String _fallbackBase64 =
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=";
}

class _ProductData {
  final String name;
  final String desc;
  final int price;
  final int id;
  final String imageUrl;

  _ProductData({
    required this.name,
    required this.desc,
    required this.price,
    required this.id,
    required this.imageUrl,
  });
}
