import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int _pageIndex = 0;

class _MainScreenState extends State<MainScreen> {
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
    );
  }
}
