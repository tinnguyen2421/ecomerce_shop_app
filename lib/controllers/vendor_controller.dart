import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/vendor_model.dart';
import 'package:http/http.dart' as http;

class VendorController {
  //fetch banners

  Future<List<Vendor>> loadVendors() async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        //ok
        List<dynamic> data = jsonDecode(response.body);

        List<Vendor> vendors =
            data.map((vendor) => Vendor.fromJson(vendor)).toList();

        return vendors;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        ///throw an execption if the server responsed with an error status code
        throw Exception('Failed to load Vendors');
      }
    } catch (e) {
      throw Exception('Error loading Vendors $e ');
    }
  }

  Future<List<Vendor>> loadVendorById(String vendorId) async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors/$vendorId'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        //ok
        List<dynamic> data = jsonDecode(response.body);

        List<Vendor> vendors =
            data.map((vendor) => Vendor.fromJson(vendor)).toList();

        return vendors;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        ///throw an execption if the server responsed with an error status code
        throw Exception('Failed to load Vendors');
      }
    } catch (e) {
      throw Exception('Error loading Vendors $e ');
    }
  }
}
