import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posttest2_ppb/main.dart';

void main() {
  testWidgets('MainApp smoke test', (WidgetTester tester) async {
    // Memuat widget utama aplikasi
    await tester.pumpWidget(const MainApp());

    // Memastikan MaterialApp berhasil dimuat
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
