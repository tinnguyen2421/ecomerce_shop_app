import 'package:ecomerce_shop_app/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider() : super([]);
  //method to set the list of categories
  void setCategories(List<Category> categories) {
    state = categories;
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryProvider, List<Category>>((ref) {
  return CategoryProvider();
});
