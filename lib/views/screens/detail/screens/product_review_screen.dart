import 'package:ecomerce_shop_app/provider/product_review_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductReviewScreen extends ConsumerWidget {
  final String productId;

  const ProductReviewScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsyncValue = ref.watch(productReviewProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Reviews"),
      ),
      body: reviewAsyncValue.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return const Center(child: Text("No reviews yet."));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.take(3).length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlkhvRuhmiOPb7hnnwSVb4hKIzm2AnJ7aj9A&s'), // Đảm bảo trường userAvatar có tồn tại
                              radius: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.fullName,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        buildStarRating(review.rating),
                        const SizedBox(height: 8),
                        Text(
                          review.review,
                          style: GoogleFonts.lato(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    double partialStar = rating - fullStars;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          );
        } else if (index == fullStars && partialStar > 0) {
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 20,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }
      }),
    );
  }
}
