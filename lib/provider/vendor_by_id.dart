import 'package:ecomerce_shop_app/models/vendor_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tạo một provider chỉ lưu 1 Vendor
class VendorByIdProvider extends StateNotifier<Vendor?> {
  VendorByIdProvider()
      : super(null); // Khởi tạo với giá trị null (không có vendor)

  // Set vendor duy nhất
  void setVendorById(Vendor vendor) {
    state = vendor; // Cập nhật vendor duy nhất
  }
}

// Khai báo provider cho 1 Vendor
final vendorByIdProvider =
    StateNotifierProvider<VendorByIdProvider, Vendor?>((ref) {
  return VendorByIdProvider();
});
