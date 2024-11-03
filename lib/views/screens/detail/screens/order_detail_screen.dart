import 'package:ecomerce_shop_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.productName,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 335,
            height: 153,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 336,
                      height: 154,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(
                            0xFFEFF0F2,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(
                          9,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 13,
                            top: 9,
                            child: Container(
                              height: 78,
                              width: 78,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFBCC5FF,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 10,
                                    top: 5,
                                    child: Image.network(
                                      order.image,
                                      width: 58,
                                      height: 67,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 14,
                            child: SizedBox(
                              width: 216,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              order.productName,
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              order.category,
                                              style: GoogleFonts.montserrat(
                                                color: const Color(
                                                  0xFF7F808C,
                                                ),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${order.productPrice.toString()}đ",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(
                                                0xFF0B0C1E,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 113,
                            child: Container(
                              height: 25,
                              width: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: order.delivered == true
                                    ? const Color(
                                        0xFF3C55EF,
                                      )
                                    : order.processing == true
                                        ? Colors.purple
                                        : Colors.red,
                                borderRadius: BorderRadius.circular(
                                  4,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 3,
                                    child: Text(
                                      order.delivered == true
                                          ? "Delivered"
                                          : order.processing == true
                                              ? "Processing"
                                              : "Cancelled",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 115,
                            left: 298,
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/icons/delete.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Container(
              width: 336,
              height: order.delivered == true ? 170 : 120,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(
                    0xFFEFF0F2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.7,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${order.state} ${order.city}${order.locality}',
                          style: GoogleFonts.lato(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'To: ${order.fullName}',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Order Id ${order.id}",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  order.delivered == true
                      ? TextButton(
                          onPressed: () {},
                          child: Text(
                            'Leave a Review',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
