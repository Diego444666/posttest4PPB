import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

// Fungsi bantu untuk memformat angka ke mata uang Rupiah
String formatRupiah(int number) {
  return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget Consumer mendengarkan perubahan data secara reaktif dari CartProvider
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // Menyaring produk yang jumlah di keranjang-nya lebih dari 0
        final cartProducts = cartProvider.products.where((product) {
          return (cartProvider.cartQuantities[product.id] ?? 0) > 0;
        }).toList();

        // Widget Scaffold menyediakan kerangka halaman keranjang belanja
        return Scaffold(
          backgroundColor: Colors.white,
          // Widget SafeArea memastikan tampilan aman dari batas layar perangkat
          body: SafeArea(
            // Widget Column menyusun elemen header, daftar item, dan total secara vertikal
            child: Column(
              children: [
                // Widget Padding memberikan jarak di sekeliling teks judul
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  // Widget Text menampilkan judul halaman Keranjang Belanja
                  child: Text(
                    'Keranjang Belanja',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                // Widget Expanded agar daftar item keranjang mengisi ruang secara fleksibel
                Expanded(
                  // Widget ListView.builder menampilkan daftar produk di keranjang secara dinamis & efisien
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      final qty = cartProvider.cartQuantities[product.id] ?? 0;

                      // Widget Card membungkus setiap kartu produk keranjang
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        // Widget ListTile menampilkan nama, jumlah, dan tombol aksi
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                            'Jumlah: $qty | Harga: ${formatRupiah(product.price * qty)}',
                          ),
                          // Widget Row menyusun tombol kurang dan hapus secara horizontal
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Widget IconButton untuk mengurangi kuantitas produk
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cartProvider.changeQuantity(
                                  product,
                                  qty - 1,
                                ),
                              ),
                              // Widget IconButton untuk menghapus produk dari keranjang secara instan
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    cartProvider.changeQuantity(product, 0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Widget Container membungkus bagian total harga dan tombol checkout di bagian bawah
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Widget BoxShadow memberikan efek bayangan estetik pada container total
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  // Widget Row menyusun rincian grand total dan tombol checkout secara horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Widget Column menampilkan label grand total beserta nominalnya
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Grand Total',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          // Widget Text menampilkan nominal grand total reaktif dari provider
                          Text(
                            formatRupiah(cartProvider.grandTotal),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Widget ElevatedButton untuk tombol aksi checkout
                      ElevatedButton(
                        onPressed: cartProvider.grandTotal > 0 ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        // Widget Text menampilkan label tombol checkout
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Widget NavigationBar di halaman keranjang dengan tombol kembali via pop
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            onDestinationSelected: (index) {
              if (index == 0) {
                // Widget Navigator.pop untuk kembali ke halaman beranda
                Navigator.pop(context);
              }
            },
            destinations: const [
              // Widget NavigationDestination untuk menu Beranda
              NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
              // Widget NavigationDestination untuk menu Keranjang
              NavigationDestination(
                icon: Icon(Icons.shopping_cart),
                label: 'Keranjang',
              ),
            ],
          ),
        );
      },
    );
  }
}
