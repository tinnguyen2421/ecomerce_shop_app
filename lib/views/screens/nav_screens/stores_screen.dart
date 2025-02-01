import 'package:ecomerce_shop_app/controllers/vendor_controller.dart';
import 'package:ecomerce_shop_app/provider/vendor_provider.dart';
import 'package:ecomerce_shop_app/views/screens/detail/screens/vendor_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    final VendorController vendorController = VendorController();
    try {
      final vendors = await vendorController.loadVendors();
      ref.read(vendorProvider.notifier).setVendors(vendors);
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of colume in grid base on the screen width
    //if the screen with is less than 600 pixels(e.g.. a phone), use columns
    //if the screen is 600 pixels ore more (e.g .. a table ),use 4 column
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    //set the aspect ratio(width-to-heigth ratio) of each grid item base on the screen width

    //for smaller screen(<600 pixels) use a ration of 3.4(taller items)

    //for larger screen(>=600 pixels), use a ratio of 4.5(more square-shaped items)

    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/cartb.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/not.png',
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            vendors.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'Danh sách cửa hàng',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
          itemCount: vendors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VendorProductsScreen(vendor: vendor);
                }));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: (vendor.storeImage != null &&
                            vendor.storeImage!.isNotEmpty)
                        ? ClipOval(
                            child: Image.network(
                              vendor.storeImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                vendor.fullName.isNotEmpty
                                    ? vendor.fullName[0].toUpperCase()
                                    : "?",
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            vendor.fullName.isNotEmpty
                                ? vendor.fullName[0].toUpperCase()
                                : "?",
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Text(
                    vendor.fullName,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.7,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
