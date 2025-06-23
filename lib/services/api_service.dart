import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/order.dart';

class ApiService {
  static const String baseUrl = 'https://efishery.acerkecil.my.id/api';

  static Future<Map<String, dynamic>> createOrder({
    required String namaPemesan,
    required int idProduct,
    required double koordinatPemesanLat,
    required double koordinatPemesanLng,
    required String totalHarga,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/order-roti'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama_pemesan': namaPemesan,
          'id_product': idProduct,
          'koordinat_pemesan_lat': koordinatPemesanLat,
          'koordinat_pemesan_lng': koordinatPemesanLng,
          'total_harga': totalHarga,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  static Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/order-roti'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
