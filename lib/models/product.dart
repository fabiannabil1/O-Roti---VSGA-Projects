class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String imageUrl;
  final String createdAt;
  final int createdBy;
  final String createdByName;
  final String updatedAt;
  final bool? isDeleted;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    required this.createdByName,
    required this.updatedAt,
    this.isDeleted,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      createdByName: json['created_by_name'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
    );
  }

  String get formattedPrice {
    return 'Rp ${double.parse(price).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
