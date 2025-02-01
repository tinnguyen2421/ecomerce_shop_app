import 'package:ecomerce_shop_app/views/screens/nav_screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const ReusableTextWidget(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              if (title.toString() == 'Categories') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CategoryScreen();
                    },
                  ),
                );
              } else if (title.toString() == 'Top Rated Products') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return CategoryScreen();
                //     },
                //   ),
                // );
              } else {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return CategoryScreen();
                //     },
                //   ),
                // );
              }
            },
            child: Text(
              subtitle,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
