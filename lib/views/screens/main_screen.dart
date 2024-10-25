import 'package:ecomerce_shop_app/views/screens/nav_screens/account_screen.dart';
import 'package:ecomerce_shop_app/views/screens/nav_screens/cart_screen.dart';
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
    HomeScreen(),
    FavoriteScreen(),
    StoresScreen(),
    CartScreen(),
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
      body: _pages[_pageIndex],
    );
  }
}
