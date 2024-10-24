import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/user.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/authencation_screen/login_screen.dart';
import 'package:ecomerce_shop_app/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
          id: '',
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: '');
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
          });
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            showSnackBar(context, "Đăng kí thành công ");
          });
    } catch (e) {
      print("error:$e");
    }
  }

//singin user func
  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(Uri.parse("$uri/api/signin"),
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      //handle response using the managehttprespone
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false);
            showSnackBar(context, "Đăng nhập thành công ");
          });
    } catch (e) {
      print("error:$e");
    }
  }
}
