import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';

  @override
  Widget build(BuildContext context) {
    final cartData = ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Address section
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 74,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFEFF0F2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircleAvatar(
                          radius: 21,
                          backgroundColor: const Color(0xFFFBF7F5),
                          child: Image.network(
                            'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
                            height: 26,
                            width: 26,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add Address',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'United States',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.3,
                              ),
                            ),
                            Text(
                              'Enter city',
                              style: GoogleFonts.lato(
                                color: const Color(0xFF7F808C),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Item List Section
              Text(
                'Your Item',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFEFF0F2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: const BoxDecoration(
                            color: Color(0xFFBCC5FF),
                          ),
                          child: Image.network(
                            cartItem.image[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  fontSize: 16,
                                  color: Colors.blueGrey,
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
                  );
                },
              ),
              const SizedBox(height: 10),
              // Payment Method Section
              Text(
                'Choose Payment method',
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
              RadioListTile<String>(
                title: Text(
                  'Cash on Delivery',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                value: 'cashOnDelivery',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 338,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF3854EE),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              selectedPaymentMethod == 'stripe' ? 'Pay Now' : 'Place Order',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
