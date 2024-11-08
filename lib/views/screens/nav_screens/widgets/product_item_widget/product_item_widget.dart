import 'package:ecomerce_shop_app/models/product.dart';
import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/provider/favorite_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
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
              height: 170,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 188, 184, 184),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        favoriteProviderData.addProductToFavorite(
                          productName: widget.product.productName,
                          productPrice: widget.product.productPrice,
                          category: widget.product.category,
                          image: widget.product.images,
                          vendorId: widget.product.vendorId,
                          productQuantity: widget.product.quantity,
                          quantity: 1,
                          productId: widget.product.id,
                          description: widget.product.description,
                          fullName: widget.product.fullName,
                        );
                        showSnackBar(
                            context, 'added ${widget.product.productName}');
                      },
                      child: favoriteProviderData.getFavoriteItems
                              .containsKey(widget.product.id)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: isInCart
                          ? null
                          : () {
                              cartProviderData.addProductToCart(
                                productName: widget.product.productName,
                                productPrice: widget.product.productPrice,
                                category: widget.product.category,
                                image: widget.product.images,
                                vendorId: widget.product.vendorId,
                                productQuantity: widget.product.quantity,
                                quantity: 1,
                                productId: widget.product.id,
                                description: widget.product.description,
                                fullName: widget.product.fullName,
                              );
                              showSnackBar(context, widget.product.productName);
                            },
                      child: Image.asset(
                        'assets/icons/cart.png',
                        height: 26,
                        width: 26,
                      ),
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
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(
                  0xff868D94,
                ),
              ),
            ),
            Text(
              "${widget.product.productPrice.toString()}đ",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
