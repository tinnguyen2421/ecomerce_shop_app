import 'dart:convert';
import 'dart:math';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:ecomerce_shop_app/models/banner_model.dart';

class BannerController {
  //fetch banners

  Future<List<BannerModel>> loadBanners() async {
    try {
      //send http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      //print(response.body);
      if (response.statusCode == 200) //ok
      {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //throw an exception if the server responded with an error status code
        throw Exception('Error loading Banners $e');
      }
    } catch (e) {
      throw Exception('Error loading Banners $e');
    }
  }
}
