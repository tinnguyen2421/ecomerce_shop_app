import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.30,
      child: Stack(
        children: [
          Image.asset(
            'assets/icons/background.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 48,
            top: 68,
            child: SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm gì đó',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0), // Khoảng cách giữa icon và text
                    child: Image.asset(
                      'assets/icons/search.png',
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Khoảng cách giữa icon và text
                    child: Image.asset('assets/icons/cam.png'),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 311,
            top: 78,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                overlayColor: MaterialStateProperty.all(
                  Color(0x07F7F),
                ),
                child: Ink(
                  width: 31,
                  height: 31,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/icons/bell.png'),
                  )),
                ),
              ),
            ),
          ),
          Positioned(
            left: 354,
            top: 78,
            child: Material(
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/messages.png'),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
