import 'package:ecomerce_shop_app/models/product.dart';
import 'package:ecomerce_shop_app/provider/favorite_provider.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TopRatedProductItemWidget extends ConsumerStatefulWidget {
  final Product product;

  const TopRatedProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<TopRatedProductItemWidget> createState() =>
      _TopRatedProductWidgetItemState();
}

class _TopRatedProductWidgetItemState
    extends ConsumerState<TopRatedProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(favoriteProvider);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(product: widget.product);
            },
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.product.images[0],
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: const Color(
                  0xFF212121,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(
                  width: 4,
                ),
                widget.product.averageRating == 0
                    ? Text(
                        'No review yet',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : Text(
                        widget.product.averageRating.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
