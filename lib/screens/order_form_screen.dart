import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/custom_appbar.dart';
import '../services/api_service.dart';
import 'location_picker_screen.dart';

class OrderFormScreen extends StatefulWidget {
  final Product product;

  const OrderFormScreen({super.key, required this.product});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemesanController = TextEditingController();
  Map<String, dynamic>? _selectedLocation;
  bool _isLoading = false;
  int _quantity = 1;

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result as Map<String, dynamic>;
      });
    }
  }

  double get _totalPrice {
    return double.parse(widget.product.price) * _quantity;
  }

  void _incrementQuantity() {
    if (_quantity < widget.product.stock) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih lokasi pengiriman')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.createOrder(
        namaPemesan: _namaPemesanController.text,
        idProduct: widget.product.id,
        koordinatPemesanLat: _selectedLocation!['latitude'],
        koordinatPemesanLng: _selectedLocation!['longitude'],
        totalHarga: _totalPrice.toString(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _namaPemesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Form Pemesanan'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Product Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produk yang Dipesan:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(widget.product.name),
                    const SizedBox(height: 4),
                    Text(
                      'Harga satuan: ${widget.product.formattedPrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Stok tersedia: ${widget.product.stock}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quantity Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Pesanan:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _quantity > 1 ? _decrementQuantity : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              _quantity < widget.product.stock
                                  ? _incrementQuantity
                                  : null,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Total: Rp ${_totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Pemesan
            TextFormField(
              controller: _namaPemesanController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama pemesan harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Location Picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lokasi Pengiriman:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedLocation != null)
                      Text(_selectedLocation!['address']),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickLocation,
                      icon: const Icon(Icons.location_on),
                      label: Text(
                        _selectedLocation == null
                            ? 'Pilih Lokasi'
                            : 'Ubah Lokasi',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Buat Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
