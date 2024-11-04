//StatNotifier for delivered order count
import 'package:ecomerce_shop_app/controllers/order_controller.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  //Method to fetch Delivered Orders count

  Future<void> fetchDeliveredOrderCount(String buyerId, context) async {
    try {
      OrderController orderController = OrderController();
      int count =
          await orderController.getDeliveredOrderCount(buyerId: buyerId);
      state = count; //Update the state with the count
    } catch (e) {
      showSnackBar(context, "Error Fetching Delivered order : $e");
    }
  }
}

final deliveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>(
  (ref) {
    return DeliveredOrderCountProvider();
  },
);
