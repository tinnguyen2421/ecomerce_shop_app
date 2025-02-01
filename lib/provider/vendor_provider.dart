import 'package:ecomerce_shop_app/models/vendor_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProvider extends StateNotifier<List<Vendor>> {
  VendorProvider() : super([]);

  //set the list of banners
  void setVendors(List<Vendor> vendors) {
    state = vendors;
  }
}

final vendorProvider =
    StateNotifierProvider<VendorProvider, List<Vendor>>((ref) {
  return VendorProvider();
});
