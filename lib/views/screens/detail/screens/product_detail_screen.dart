import 'package:ecomerce_shop_app/controllers/product_controller.dart';
import 'package:ecomerce_shop_app/models/product.dart';
import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/provider/favorite_provider.dart';
import 'package:ecomerce_shop_app/provider/related_product_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
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
final List<Map<String, dynamic>> productReviews = [
  {
    'rating': 5,
    'comment': 'Sản phẩm tuyệt vời, chất lượng tốt và dễ sử dụng!',
    'userName': 'Nguyễn Văn A',
    'userAvatar':
        'https://www.example.com/avatar1.jpg', // Đường dẫn tới ảnh avatar
  },
  {
    'rating': 4,
    'comment': 'Chất lượng ổn, nhưng có một chút thiếu sót về thiết kế.',
    'userName': 'Trần Thị B',
    'userAvatar':
        'https://www.example.com/avatar2.jpg', // Đường dẫn tới ảnh avatar
  },
  {
    'rating': 3,
    'comment': 'Sản phẩm bình thường, không có gì nổi bật.',
    'userName': 'Lê Minh C',
    'userAvatar':
        'https://www.example.com/avatar3.jpg', // Đường dẫn tới ảnh avatar
  },
  {
    'rating': 2,
    'comment': 'Không giống như mô tả, tôi không hài lòng với sản phẩm.',
    'userName': 'Phan Quân D',
    'userAvatar':
        'https://www.example.com/avatar4.jpg', // Đường dẫn tới ảnh avatar
  },
  {
    'rating': 1,
    'comment': 'Tôi không thích sản phẩm này chút nào.',
    'userName': 'Vũ Mai E',
    'userAvatar':
        'https://www.example.com/avatar5.jpg', // Đường dẫn tới ảnh avatar
  },
];

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProduct();
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

  @override
  Widget build(BuildContext context) {
    final relatedProduct = ref.watch(relatedProductProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);

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
              width: 36, // Kích thước container của icon back
              height: 36, // Kích thước container của icon back
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
                padding:
                    EdgeInsets.only(right: 8.0), // Thêm khoảng cách từ lề phải
                child: Container(
                  width: 36, // Kích thước container của icon favorite
                  height: 36, // Kích thước container của icon favorite
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
                            size: 24, // Kích thước icon giống nhau
                          )
                        : Icon(
                            Icons.favorite_border,
                            color:
                                _isAppBarExpanded ? Colors.pink : Colors.white,
                            size: 24, // Kích thước icon giống nhau
                          ),
                    onPressed: () {
                      // Thêm hoặc bỏ sản phẩm khỏi danh sách yêu thích
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
                              ? 'Removed from favorites'
                              : 'Added to favorites');
                    },
                  ),
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
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
                      Text(" | "),
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
                            ? "No review yet"
                            : widget.product.averageRating.toString(),
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
                          title: 'Store Information',
                          subtitle: '',
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(''),
                              radius: 28,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'vendor!.name',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'active 24 minutes ago',
                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                Text(
                                  'address',
                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(width: 70),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('View Shop'),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                        "Describe:",
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
                    maxLines: isExpanded ? null : 3,
                    style: GoogleFonts.lato(fontSize: 15),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                              fontWeight: FontWeight.w600, color: Colors.pink),
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
                            title: 'Related Products',
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
                    : SizedBox.shrink(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ReusableTextWidget(
                        title: 'Product Reviews',
                        subtitle: '',
                      ),
                      ListView.builder(
                        shrinkWrap:
                            true, // Sử dụng shrinkWrap để tránh khoảng trống
                        physics:
                            NeverScrollableScrollPhysics(), // Tránh cuộn trong cuộn
                        itemCount: productReviews.take(3).length,
                        itemBuilder: (context, index) {
                          final review = productReviews[index];
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
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              review['userAvatar']),
                                          radius: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          review['userName'],
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    buildStarRating(
                                        review['rating'].toDouble()),
                                    const SizedBox(height: 8),
                                    Text(
                                      review['comment'],
                                      style: GoogleFonts.lato(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          // Hành động khi bấm vào "Xem Thêm"
                          print("Xem Thêm clicked");
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0), // Tăng khoảng trống
                          child: Center(
                            child: Text(
                              "Xem tất cả",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],

// Review List
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
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
                  showSnackBar(context, 'Added to cart');
                },
          child: Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              color: isInCart ? Colors.grey : const Color(0xFF3B54EE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                isInCart ? "GO TO CART" : "ADD TO CART",
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
        return Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        );
      } else if (index == fullStars && partialStar > 0) {
        return Icon(
          Icons.star_half,
          color: Colors.amber,
          size: 20,
        );
      } else {
        return Icon(
          Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }
    }),
  );
}
