import 'package:ecomerce_shop_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProductsProvider extends StateNotifier<List<Product>> {
  VendorProductsProvider() : super([]);

  // Set the list of products
  void setProducts(List<Product> products) {
    state = products;
  }

  // Clear the list of products
  void clearProducts() {
    state = [];
  }
}

final vendorProductProvider =
    StateNotifierProvider<VendorProductsProvider, List<Product>>((ref) {
  return VendorProductsProvider();
});
