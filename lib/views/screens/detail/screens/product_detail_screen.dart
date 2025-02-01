import 'package:ecomerce_shop_app/controllers/product_controller.dart';
import 'package:ecomerce_shop_app/controllers/vendor_controller.dart';
import 'package:ecomerce_shop_app/models/product.dart';
import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/provider/favorite_provider.dart';
import 'package:ecomerce_shop_app/provider/product_review_provider.dart';
import 'package:ecomerce_shop_app/provider/related_product_provider.dart';
import 'package:ecomerce_shop_app/provider/vendor_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/product_review_screen.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/vendor_products_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/cart_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/product_item_widget/product_item_widget.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

bool isExpanded = false;
final List<Map<String, dynamic>> productReviews = [];

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProduct();
    _fetchVendor();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 130 && !_isAppBarExpanded) {
      setState(() {
        _isAppBarExpanded = true;
      });
    } else if (_scrollController.offset <= 130 && _isAppBarExpanded) {
      setState(() {
        _isAppBarExpanded = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final productController = ProductController();
    try {
      final products = await productController
          .loadRelatedProductsBySubcategory(widget.product.id);
      ref.read(relatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      print('$e');
    }
  }

  Future<void> _fetchVendor() async {
    final vendorController = VendorController();
    try {
      // Lấy tất cả các vendor từ API
      final vendors = await vendorController.loadVendors();

      // Cập nhật state của vendorProvider với danh sách các vendor
      ref.read(vendorProvider.notifier).setVendors(vendors);

      // Lấy danh sách các vendor từ provider
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorList = ref.watch(vendorProvider);

    // Tìm vendor có id trùng với widget.product.vendorId
    final vendor = vendorList.firstWhere(
      (v) => v.id == widget.product.vendorId,
      // orElse: () => Vendor(
      //     id: '',
      //     fullName: '',
      //     email: '',
      //     state: '',
      //     city: '',
      //     locality: '',
      //     role: '',
      //     password: '',
      //     token: ''),
    );

    final relatedProduct = ref.watch(relatedProductProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    final reviewAsyncValue =
        ref.watch(productReviewProvider(widget.product.id));

    final isShortDescription =
        widget.product.description.split('\n').length <= 3;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 276,
            floating: false,
            pinned: true,
            backgroundColor:
                _isAppBarExpanded ? Colors.white : Colors.transparent,
            iconTheme: IconThemeData(
              color: _isAppBarExpanded ? Colors.pink : Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: widget.product.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.product.images[index],
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: _isAppBarExpanded ? Colors.pink : Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: ref
                            .watch(favoriteProvider)
                            .containsKey(widget.product.id)
                        ? Icon(
                            Icons.favorite,
                            color: _isAppBarExpanded ? Colors.pink : Colors.red,
                            size: 24,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color:
                                _isAppBarExpanded ? Colors.pink : Colors.white,
                            size: 24,
                          ),
                    onPressed: () {
                      if (ref
                          .read(favoriteProvider)
                          .containsKey(widget.product.id)) {
                        favoriteProviderData
                            .removeFavoriteItem(widget.product.id);
                      } else {
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
                      }
                      showSnackBar(
                          context,
                          ref
                                  .read(favoriteProvider)
                                  .containsKey(widget.product.id)
                              ? 'Thêm vào danh sách yêu thích'
                              : 'Đã xóa khỏi danh sách yêu thích');
                    },
                  ),
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.product.productName,
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3C55EF),
                        ),
                      ),
                      const Text(" | "),
                      Text(
                        "(${widget.product.category})",
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3C55EF),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.product.productPrice}đ",
                    style: GoogleFonts.roboto(
                      color: Colors.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        widget.product.totalRatings == 0
                            ? "Chưa có đánh giá"
                            : widget.product.averageRating.toStringAsFixed(1),
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      Text('(${widget.product.totalRatings})'),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ReusableTextWidget(
                          title: 'Thông tin cửa hàng',
                          subtitle: '',
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: vendor.storeImage != ""
                                  ? NetworkImage(vendor.storeImage!)
                                  : const NetworkImage(
                                      "https://img.freepik.com/free-vector/shop-with-sign-we-are-open_52683-38687.jpg"),
                              radius: 28,
                            ),
                            const SizedBox(width: 12),

                            // Sử dụng Expanded để tên cửa hàng không bị tràn ra ngoài màn hình
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendor.fullName,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1, // Giới hạn hiển thị 1 dòng
                                    overflow: TextOverflow
                                        .ellipsis, // Thêm dấu "..." nếu quá dài
                                  ),
                                  Text(
                                    'Hoạt động 24 phút trước',
                                    style: GoogleFonts.lato(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    vendor.storeDescription!,
                                    style: GoogleFonts.lato(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return VendorProductsScreen(
                                          vendor: vendor,
                                        );
                                      }));
                                    },
                                    child: const Text('Xem cửa hàng'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mô tả sản phẩm:",
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          color: const Color(0xFF363330),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 64),
                  child: Text(
                    widget.product.description,
                    maxLines: isExpanded || isShortDescription ? null : 3,
                    style: GoogleFonts.lato(fontSize: 15),
                  ),
                ),
                // Nếu mô tả dài hơn 3 dòng, hiển thị nút "Xem thêm"
                if (!isShortDescription)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            isExpanded ? "Thu Gọn" : "Xem Thêm",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.pink),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            isExpanded
                                ? Icons.arrow_upward
                                : Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.pink,
                          ),
                        ],
                      ),
                    ),
                  ),
                relatedProduct.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ReusableTextWidget(
                            title: 'Các sản phẩm liên quan',
                            subtitle: '',
                          ),
                          SizedBox(
                            height: 256,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProduct.length,
                              itemBuilder: (context, index) {
                                final product = relatedProduct[index];
                                return ProductItemWidget(
                                  product: product,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ReusableTextWidget(
                        title: 'Đánh giá sản phẩm',
                        subtitle: '',
                      ),
                      reviewAsyncValue.when(
                        data: (reviews) {
                          // Kiểm tra nếu không có đánh giá
                          if (reviews.isEmpty) {
                            return const Center(
                                child: Text("Chưa có đánh giá nào."));
                          }

                          // Nếu có đánh giá, hiển thị danh sách đánh giá
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap:
                                    true, // Sử dụng shrinkWrap để tránh khoảng trống
                                physics:
                                    const NeverScrollableScrollPhysics(), // Tránh cuộn trong cuộn
                                itemCount: reviews
                                    .take(3)
                                    .length, // Giới hạn 3 phần tử đầu tiên
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlkhvRuhmiOPb7hnnwSVb4hKIzm2AnJ7aj9A&s'),
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
                                              style: GoogleFonts.lato(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Hiển thị nút "Xem tất cả" nếu có ít hơn 3 đánh giá
                              if (reviews.length > 3)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ProductReviewScreen(
                                          productId: widget.product.id);
                                    }));
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Center(
                                      child: Text(
                                        "Xem tất cả",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.pink),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Error: $error")),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomSheet: isInCart
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CartScreen();
                  }));
                },
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B54EE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      "Thanh toán",
                      style: GoogleFonts.mochiyPopOne(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
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
                  showSnackBar(context, 'Đã thêm vào giỏ hàng');
                },
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B54EE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      "Thêm vào giỏ hàng",
                      style: GoogleFonts.mochiyPopOne(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Widget buildStarRating(double rating) {
  int fullStars = rating.floor(); // Số sao đầy đủ
  double partialStar = rating - fullStars; // Số sao còn lại (nếu có)

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
