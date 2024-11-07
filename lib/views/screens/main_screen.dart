import 'package:ecomerce_shop_app/views/screens/nav_screens/account_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/cart_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/category_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/home_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/stores_screen.dart';
import 'package:flutter/material.dart';

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
    AccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Trang chủ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "Yêu thích",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: "Thể loại",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_mall_directory_outlined),
              label: "Cửa hàng",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Giỏ hàng",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "Tài khoản",
            )
          ]),
      body: _pages[_pageIndex],
    );
  }
}
