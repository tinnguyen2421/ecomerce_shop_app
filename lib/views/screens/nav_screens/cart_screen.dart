import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/checkout_screen.dart';
import 'package:ecomerce_shop_app/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = _cartProvider.calculateTotalAmount();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/not.png',
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            cartData.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'Giỏ hàng',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Giỏ hàng của bạn trống\nBạn có thể thêm sản phẩm vào giỏ hàng từ nút bên dưới',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(fontSize: 15, letterSpacing: 1.7),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainScreen();
                      }));
                    },
                    child: const Text('Mua ngay'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 49,
                  decoration: const BoxDecoration(color: Color(0xFFD7DDFF)),
                  child: Row(
                    children: [
                      const SizedBox(width: 44),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Bạn có ${cartData.length} sản phẩm',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      return Card(
                        child: SizedBox(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  cartItem.image[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${cartItem.productName}/${cartItem.category}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${cartItem.productPrice.toStringAsFixed(0)}đ",
                                    style: GoogleFonts.lato(
                                      color: Colors.pink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _cartProvider.decrementCartItem(
                                              cartItem.productId);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.minus_circle_fill,
                                          color: Colors.redAccent,
                                          size: 25,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cartItem.quantity.toString(),
                                        style: const TextStyle(
                                          color: Color(0xFF1532E7),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          _cartProvider.incrementCartItem(
                                              cartItem.productId);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.plus_circle_fill,
                                          color: Colors.green,
                                          size: 25,
                                        ),
                                      ),
                                      const SizedBox(width: 110),
                                      IconButton(
                                        onPressed: () {
                                          _cartProvider.removeCartItem(
                                              cartItem.productId);
                                        },
                                        icon: const Icon(CupertinoIcons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: totalAmount > 0
          ? Container(
              width: 416,
              height: 89,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFC4C4C4)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-0.63, -0.26),
                    child: Text(
                      'Tổng tiền',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA1A1A1),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.19, -0.31),
                    child: Text(
                      "${totalAmount.toStringAsFixed(0)}đ",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF6464),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.83, -1),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CheckoutScreen();
                        }));
                      },
                      child: Container(
                        width: 166,
                        height: 71,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1532E7),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thanh toán',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(), // Nếu totalAmount = 0, render SizedBox (không hiển thị gì)
    );
  }
}
