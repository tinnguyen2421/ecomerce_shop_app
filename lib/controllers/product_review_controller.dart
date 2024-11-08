import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/product_review.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:http/http.dart' as http;

class ProductReviewController {
  uploadReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context,
  }) async {
    try {
      final ProductReview productReview = ProductReview(
          id: '',
          buyerId: buyerId,
          email: email,
          fullName: fullName,
          productId: productId,
          rating: rating,
          review: review);
      http.Response response = await http.post(
        Uri.parse("$uri/api/product-review"),
        body: productReview.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'You have added an review');
          });
    } catch (e) {}
  }

  Future<List<ProductReview>> getReviewsByProductId(String productId) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/reviews/$productId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> reviewsData = json.decode(response.body)['reviews'];

        List<ProductReview> reviews = reviewsData
            .map((item) => ProductReview.fromMap(item as Map<String, dynamic>))
            .toList();

        return reviews;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Không thể tải đánh giá');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải đánh giá: $e');
    }
  }
}
