import 'package:flutter/foundation.dart';

// Model Product disatukan di sini agar tidak perlu file/folder terpisah
class Product {
  final String id;
  final String imagePath;
  final String name;
  int stock;
  final String description;
  final int price;

  Product({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.stock,
    required this.description,
    required this.price,
  });
}

// Class CartProvider turunan ChangeNotifier untuk mengelola state global aplikasi
class CartProvider extends ChangeNotifier {
  // Daftar produk yang tersedia di toko
  final List<Product> products = [
    Product(
      id: 'produk-1',
      imagePath: 'assets/product.png',
      name: 'Produk Satu',
      stock: 5,
      description: 'Deskripsi singkat produk satu',
      price: 12000000,
    ),
    Product(
      id: 'produk-2',
      imagePath: 'assets/product.png',
      name: 'Produk Dua',
      stock: 4,
      description: 'Deskripsi singkat produk dua',
      price: 8500000,
    ),
    Product(
      id: 'produk-3',
      imagePath: 'assets/product.png',
      name: 'Produk Tiga',
      stock: 3,
      description: 'Deskripsi singkat produk tiga',
      price: 6500000,
    ),
  ];

  // Peta untuk menyimpan jumlah kuantitas produk di dalam keranjang
  final Map<String, int> cartQuantities = {};

  // Fungsi untuk menambahkan produk ke keranjang
  void addToCart(Product product) {
    if (product.stock == 0) return;
    product.stock--;
    cartQuantities[product.id] = (cartQuantities[product.id] ?? 0) + 1;
    notifyListeners(); // Memberitahu widget yang mendengarkan (Consumer) bahwa ada perubahan state
  }

  // Fungsi untuk mengubah jumlah kuantitas atau menghapus produk dari keranjang
  void changeQuantity(Product product, int quantity) {
    final currentQuantity = cartQuantities[product.id] ?? 0;
    final maxQuantity = currentQuantity + product.stock;
    final nextQuantity = quantity.clamp(0, maxQuantity);

    if (nextQuantity <= 0) {
      product.stock += currentQuantity;
      cartQuantities.remove(product.id);
    } else {
      product.stock += currentQuantity - nextQuantity;
      cartQuantities[product.id] = nextQuantity;
    }
    notifyListeners(); // Memperbarui UI secara reaktif
  }

  // Getter untuk menghitung total harga secara dinamis
  int get grandTotal {
    return products.fold(0, (total, product) {
      return total + (product.price * (cartQuantities[product.id] ?? 0));
    });
  }
}
