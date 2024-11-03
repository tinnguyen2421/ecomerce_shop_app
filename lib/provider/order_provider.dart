import 'package:ecomerce_shop_app/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);
  //set the list of Orders
  void setOrders(List<Order> orders) async {
    state = orders;
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
