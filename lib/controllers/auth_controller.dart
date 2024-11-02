import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/user.dart';
import 'package:ecomerce_shop_app/provider/user_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/authencation_screen/login_screen.dart';
import 'package:ecomerce_shop_app/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();
final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());

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
          onSuccess: () async {
            //Access sharePreference for token and user data storage
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            //Extract the authencation token from the response body
            String token = jsonDecode(response.body)['token'];
            //Store the authencation token sercurely in SharePreference
            await sharedPreferences.setString('auth_token', token);

            //Encode the user data recived from the backend as json
            final userJson = jsonEncode(jsonDecode(response.body)['user']);

            //Update the application state with the user data using Riverpod
            providerContainer.read(userProvider.notifier).setUser(userJson);

            //store the data in sharePreference for future use
            await sharedPreferences.setString('user', userJson);
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

  //signOut
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //clear the token and user from sharePreference
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //clear the user state
      providerContainer.read(userProvider.notifier).signOut();
      //navigate the user back to the login screen
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (route) => false);
      showSnackBar(context, 'SignOut Successfully');
    } catch (e) {
      showSnackBar(context, 'Error signing out');
    }
  }
}
