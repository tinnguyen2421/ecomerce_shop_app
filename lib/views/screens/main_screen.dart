import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/account_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/cart_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/category_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/home_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/stores_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        height: 60.0,
        color: const Color(0xFF103DE5),
        buttonBackgroundColor: const Color(0xFF103DE5),
        backgroundColor: Colors.transparent,
        items: const <Widget>[
          Icon(Icons.home, size: 27, color: Colors.white),
          Icon(Icons.favorite, size: 27, color: Colors.white),
          Icon(Icons.category, size: 27, color: Colors.white),
          Icon(Icons.store_mall_directory, size: 27, color: Colors.white),
          Icon(Icons.shopping_bag, size: 27, color: Colors.white),
          Icon(Icons.person_2, size: 27, color: Colors.white),
        ],
      ),
    );
  }
}
