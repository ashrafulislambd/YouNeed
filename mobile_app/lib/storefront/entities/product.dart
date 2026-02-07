class Product {
  int? id;
  String? title;
  String? description;

  // Base64 encoded image
  String? image;

  int? price;
  int? categoryId;

  Product(
    this.title,
    this.description,
    this.price,
    this.categoryId,
    this.image,
  );
}
