import 'package:ecomerce_shop_app/controllers/order_controller.dart';
import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/provider/user_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/shipping_address_screen.dart';
import 'package:ecomerce_shop_app/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';
  final OrderController _orderController = OrderController();
  bool isLoading = false;
  Future<void> handleStripePayment(BuildContext context) async {
    //fetch the cart data from riverpod provider
    final cartData = ref.read(cartProvider);
    //fetch the user data from riverpod provider
    final user = ref.read(userProvider);
    //check if the cart is empty
    if (cartData.isEmpty) {
      showSnackBar(context, "Your cart it empty");
      return;
    }
    //check if user is null
    if (user == null) {
      showSnackBar(context, "User information is missing");
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      //calculate the total amount for all item in cart
      final totalAmount = cartData.values
          .fold(0.0, (sum, item) => sum + (item.quantity * item.productPrice));
      //check if the totalAmount is a valid amount
      if (totalAmount <= 0) {
        showSnackBar(context, "Total Amount mus be greater than zero");
      }
      //create a payment intent with the calculated amount and currency
      final paymentIntent = await _orderController.createPaymentIntent(
          amount: (totalAmount * 100).toInt(), currency: 'usd');
      //initialize the stripe payment sheet with the payment intent details
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        merchantDisplayName: 'Nguyen Trong Tin',
      ));
      //present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      final paymentIntentStatus = await _orderController.getPaymentIntentStatus(
          context: context, paymentIntentId: paymentIntent['id']);
      //upload each cart item as an order to the server
      if (paymentIntentStatus['status'] == 'succeeded') {
        for (final entry in cartData.entries) {
          final item = entry.value;
          await _orderController.uploadOrders(
            id: '',
            productId: item.productId,
            fullName: ref.read(userProvider)!.fullName,
            email: ref.read(userProvider)!.email,
            state: ref.read(userProvider)!.state,
            city: ref.read(userProvider)!.city,
            locality: ref.read(userProvider)!.locality,
            productName: item.productName,
            productPrice: item.productPrice,
            quantity: item.quantity,
            category: item.category,
            image: item.image[0],
            buyerId: ref.read(userProvider)!.id,
            vendorId: item.vendorId,
            processing: true,
            delivered: false,
            context: context,
            paymentStatus: paymentIntentStatus['status'],
            paymentIntentId: paymentIntentStatus['id'],
            paymentMethod: 'card',
          );
        }
      }
    } catch (e) {
      showSnackBar(context, "Payment failed:$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.read(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 15,
        ),
        child: SingleChildScrollView(
          // Wrap the entire content in a SingleChildScrollView
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ShippingAddressScreen();
                    }));
                  },
                  child: SizedBox(
                    width: 375,
                    height: 74,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 375,
                            height: 74,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(
                                  0xFFEFF0F2,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 60,
                          top: 17,
                          child: SizedBox(
                            width: 215,
                            height: 41,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -1,
                                  left: -1,
                                  child: SizedBox(
                                    width: 219,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            width: 114,
                                            child: user!.state.isNotEmpty
                                                ? const Text(
                                                    'Địa chỉ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.1,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Thêm địa chỉ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.1,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: user.state.isNotEmpty
                                              ? Text(
                                                  user.state,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.3,
                                                  ),
                                                )
                                              : Text(
                                                  'Nhập thành phố, tỉnh',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.3,
                                                  ),
                                                ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: user.city.isNotEmpty
                                              ? Text(
                                                  user.city,
                                                  style: GoogleFonts.lato(
                                                    color:
                                                        const Color(0xFF7F808C),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              : Text(
                                                  'Chọn quận, huyện',
                                                  style: GoogleFonts.lato(
                                                    color:
                                                        const Color(0xFF7F808C),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 16,
                          child: SizedBox.square(
                            dimension: 42,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 43,
                                    height: 43,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFBF7F5,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        Positioned(
                                          left: 11,
                                          top: 11,
                                          child: Image.network(
                                            height: 26,
                                            width: 26,
                                            'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 305,
                          top: 25,
                          child: Image.network(
                            width: 20,
                            height: 20,
                            'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 5,
                ),
                ListView.builder(
                  itemCount: cartData.length,
                  shrinkWrap:
                      true, // Ensures the list does not take more space than needed
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents scrolling inside ListView
                  itemBuilder: (context, index) {
                    final cartItem = cartData.values.toList()[index];

                    return InkWell(
                      onTap: () {},
                      child: Container(
                        width: 336,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFEFF0F2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 78,
                                  height: 78,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFBCC5FF),
                                  ),
                                  child: Image.network(
                                    cartItem.image[0],
                                  ),
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartItem.productName,
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cartItem.category,
                                        style: GoogleFonts.lato(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "${cartItem.productPrice.toStringAsFixed(0)}đ",
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: 14,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey.shade400,
                            ),
                            // Row chứa thông tin voucher nằm ngay dưới hình ảnh
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/voucher.png',
                                        height: 25,
                                        width: 25,
                                        // color: const Color(0xFF103DE5),
                                      ),
                                      const Text(
                                        ' Voucher của shop',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Chọn hoặc nhập mã >',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey.shade400,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lời nhắn cho shop',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                  Text(
                                    'Để lại lời nhắn',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Chọn phương thức thanh toán',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RadioListTile<String>(
                  title: Text(
                    'Stripe',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  value: 'stripe',
                  groupValue: selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                RadioListTile<String>(
                    title: Text(
                      'Cash on Delivery',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: 'cashOnDelivery',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: user.state.isEmpty
            ? TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShippingAddressScreen();
                  }));
                },
                child: Text(
                  'Vui lòng nhập địa chỉ giao hàng',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              )
            : InkWell(
                onTap: () async {
                  if (selectedPaymentMethod == 'stripe') {
                    //print(ref.watch(userProvider)!.state);
                    handleStripePayment(context);
                  } else {
                    await Future.forEach(_cartProvider.getCartItems.entries,
                        (entry) {
                      var item = entry.value;
                      _orderController.uploadOrders(
                        id: '',
                        productId: item.productId,
                        fullName: ref.read(userProvider)!.fullName,
                        email: ref.read(userProvider)!.email,
                        state: ref.read(userProvider)!.state,
                        city: ref.read(userProvider)!.city,
                        locality: ref.read(userProvider)!.locality,
                        productName: item.productName,
                        productPrice: item.productPrice,
                        quantity: item.quantity,
                        category: item.category,
                        image: item.image[0],
                        buyerId: ref.read(userProvider)!.id,
                        vendorId: item.vendorId,
                        processing: true,
                        delivered: false,
                        context: context,
                        paymentStatus: "pending",
                        paymentIntentId: 'cod',
                        paymentMethod: 'cod',
                      );
                    }).then((value) {
                      _cartProvider.clearCart();
                      showSnackBar(context, 'Đơn hàng đã được đặt thành công');
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MainScreen();
                      }));
                    });
                  }
                },
                child: Container(
                  width: 338,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF3854EE,
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            selectedPaymentMethod == 'stripe'
                                ? 'Thanh toán ngay'
                                : "Đặt hàng",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
