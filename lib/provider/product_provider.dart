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
