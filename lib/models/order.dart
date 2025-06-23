class Order {
  final int id;
  final String namaPemesan;
  final int idProduct;
  final double? koordinatPemesanLat;
  final double? koordinatPemesanLng;
  final double totalHarga;
  final String createdAt;
  final String productName;
  final String productPrice;

  Order({
    required this.id,
    required this.namaPemesan,
    required this.idProduct,
    this.koordinatPemesanLat,
    this.koordinatPemesanLng,
    required this.totalHarga,
    required this.createdAt,
    required this.productName,
    required this.productPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      namaPemesan: json['nama_pemesan'],
      idProduct: json['id_product'],
      koordinatPemesanLat: json['koordinat_pemesan_lat'],
      koordinatPemesanLng: json['koordinat_pemesan_lng'],
      totalHarga: json['total_harga'].toDouble(),
      createdAt: json['created_at'],
      productName: json['product_name'],
      productPrice: json['product_price'],
    );
  }
}
