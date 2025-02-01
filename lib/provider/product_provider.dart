import 'package:ecomerce_shop_app/controllers/product_controller.dart';
import 'package:ecomerce_shop_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);
  //set the list of products
  void setProducts(List<Product> products) {
    state = products;
  }
}

final productProvider =
    StateNotifierProvider<ProductProvider, List<Product>>((ref) {
  return ProductProvider();
});
final productBySubCategoryProvider =
    FutureProvider.family<List<dynamic>, String>((ref, subcategoryName) async {
  final productController = ProductController();
  try {
    // Sử dụng phương thức loadProductBySubcategory của controller
    final products =
        await productController.loadProductBySubcategory(subcategoryName);
    return products;
  } catch (e) {
    throw e;
  }
});
