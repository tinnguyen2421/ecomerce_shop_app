import 'package:ecomerce_shop_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
          ],
        ),
      ),
    );
  }
}
