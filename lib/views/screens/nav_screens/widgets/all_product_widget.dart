import 'package:ecomerce_shop_app/controllers/product_controller.dart';
import 'package:ecomerce_shop_app/provider/product_provider.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/product_item_widget/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllProductWidget extends ConsumerStatefulWidget {
  const AllProductWidget({super.key});

  @override
  ConsumerState<AllProductWidget> createState() => _AllProductWidgetState();
}

class _AllProductWidgetState extends ConsumerState<AllProductWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      isLoading = false;
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadAllProduct();
      ref.read(productProvider.notifier).setProducts(products);
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    int rowCount = (products.length / 2).ceil(); // Tính số hàng cần thiết
    double itemHeight = 300.0; // Chiều cao mỗi hàng
    double gridHeight = rowCount * itemHeight;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : SizedBox(
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
  }
}
