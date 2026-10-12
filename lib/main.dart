import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'cartPage.dart';

void main() {
  // Widget MultiProvider mendaftarkan provider global ke seluruh aplikasi
  runApp(
    MultiProvider(
      providers: [
        // Widget ChangeNotifierProvider menyediakan instance CartProvider
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget MaterialApp mengatur konfigurasi dasar Material Design aplikasi
    return MaterialApp(
      // Widget ThemeData mengatur tema visual global aplikasi
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Widget Consumer digunakan untuk mendengarkan perubahan state dari CartProvider
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // Menyaring produk berdasarkan kata kunci pencarian
        final visibleProducts = cartProvider.products.where((product) {
          return product.stock > 0 &&
              product.name.toLowerCase().contains(searchQuery);
        }).toList();

        // Widget Scaffold menyediakan kerangka visual struktur halaman dasar
        return Scaffold(
          backgroundColor: Colors.white,
          // Widget SafeArea memastikan konten tidak tertutup notch atau system UI perangkat
          body: SafeArea(
            // Widget Column menyusun widget anak secara vertikal
            child: Column(
              children: [
                // Widget Padding memberikan jarak di sekeliling search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 28,
                  ),
                  // Widget TextField untuk menerima input pencarian produk
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => searchQuery = value.toLowerCase()),
                    // Widget InputDecoration mengatur dekorasi border dan ikon
                    decoration: InputDecoration(
                      hintText: 'Cari Produk',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                // Widget Expanded agar daftar produk mengisi sisa ruang secara fleksibel
                Expanded(
                  // Widget SingleChildScrollView membuat area daftar produk dapat di-scroll
                  child: SingleChildScrollView(
                    // Widget Padding memberikan jarak pada kontainer daftar produk
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      // Widget Column menyusun daftar kartu produk secara vertikal
                      child: Column(
                        children: [
                          for (var i = 0; i < visibleProducts.length; i++) ...[
                            // Widget Card membungkus informasi produk dengan efek elevated
                            Card(
                              elevation: 2,
                              // Widget ListTile menyusun informasi teks dan tombol dalam satu baris rapi
                              child: ListTile(
                                title: Text(visibleProducts[i].name),
                                subtitle: Text(
                                  'Stok: ${visibleProducts[i].stock}',
                                ),
                                // Widget ElevatedButton untuk tombol interaksi beli
                                trailing: ElevatedButton(
                                  onPressed: () => cartProvider.addToCart(
                                    visibleProducts[i],
                                  ),
                                  child: const Text('Beli'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Widget NavigationBar mengatur navigasi bawah antar halaman utama
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index == 1) {
                // Widget Navigator.push berpindah ke halaman Keranjang (CartPage)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
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
