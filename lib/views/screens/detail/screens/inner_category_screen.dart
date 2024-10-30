import 'package:ecomerce_shop_app/models/category.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/widgets/inner_category_content_widget.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/account_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/cart_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/category_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/stores_screen.dart';
import 'package:flutter/material.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;

  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InnerCategoryContentWidget(
        category: widget.category,
      ),
      const FavoriteScreen(),
      const CategoryScreen(),
      const StoresScreen(),
      const CartScreen(),
      AccountScreen()
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/home.png",
                  width: 25,
                ),
                label: "Trang chủ"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/love.png",
                  width: 25,
                ),
                label: "Yêu thích"),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Thể loại",
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/mart.png",
                  width: 25,
                ),
                label: "Cửa hàng"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/cart.png",
                  width: 25,
                ),
                label: "Giỏ hàng"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/account.png",
                  width: 25,
                ),
                label: "Tài khoản")
          ]),
      body: pages[pageIndex],
    );
  }
}
