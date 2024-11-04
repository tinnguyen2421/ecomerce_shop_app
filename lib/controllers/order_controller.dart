import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/order.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  //function to upload orders
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      final Order order = Order(
          id: id,
          fullName: fullName,
          email: email,
          state: state,
          city: city,
          locality: locality,
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          category: category,
          image: image,
          buyerId: buyerId,
          vendorId: vendorId,
          processing: processing,
          delivered: delivered);
      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'You have placed an order');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //method to GET Orders by buyerId
  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      //Send an HTTP GET request to get the orders by the buyerId
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$buyerId'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      //Check if the response status code is 200(Ok).
      if (response.statusCode == 200) {
        //Parse the json response body into dynamic List
        //This convert the json data into a formate that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        //Map the dynamic list to list of orders object using the fromJson factory method
        //this step convert the raw data into list of the orders instance, which are easier to work with
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else {
        //throw an exception if the server responded with an erro status code
        throw Exception('Failed to load Orders');
      }
    } catch (e) {
      throw Exception('Rrror loading Orders');
    }
  }

  //DELETE order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      //send HTTP delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      //handle the HTTP response
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order Deleted successfully');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    //Method to count delivered orders
  }

  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      //load all order
      List<Order> orders = await loadOrders(buyerId: buyerId);
      //Filter ony delivered orders
      int deliveredCount = orders.where((order) => order.delivered).length;

      return deliveredCount;
    } catch (e) {
      throw Exception("Error counting  Delivered Orders");
    }
  }
}
