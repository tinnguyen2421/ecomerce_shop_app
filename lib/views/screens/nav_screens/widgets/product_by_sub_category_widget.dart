import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/product_item_widget/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecomerce_shop_app/provider/product_provider.dart';

class ProductBySubCategoryWidget extends ConsumerWidget {
  final String subcategoryName;

  const ProductBySubCategoryWidget({super.key, required this.subcategoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe provider với subcategoryName
    final productsAsync =
        ref.watch(productBySubCategoryProvider(subcategoryName));

    return productsAsync.when(
      data: (products) {
        int rowCount = (products.length / 2).ceil(); // Tính số hàng cần thiết
        double itemHeight = 300.0; // Chiều cao mỗi hàng
        double gridHeight = rowCount * itemHeight;

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: products.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ProductItemWidget(
                  product: product,
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, stack) => Center(
        child: Text("Error: $e"),
      ),
    );
  }
}
