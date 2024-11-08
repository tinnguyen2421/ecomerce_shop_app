import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecomerce_shop_app/models/product_review.dart';
import 'package:ecomerce_shop_app/controllers/product_review_controller.dart';

final productReviewProvider =
    FutureProvider.family<List<ProductReview>, String>((ref, productId) async {
  final controller = ProductReviewController();
  return await controller.getReviewsByProductId(productId);
});
