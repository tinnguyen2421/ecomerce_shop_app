import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/user.dart';
import 'package:ecomerce_shop_app/provider/cart_provider.dart';
import 'package:ecomerce_shop_app/provider/delivered_order_count_provider.dart';
import 'package:ecomerce_shop_app/provider/favorite_provider.dart';
import 'package:ecomerce_shop_app/provider/user_provider.dart';
import 'package:ecomerce_shop_app/services/manage_http_respone.dart';
import 'package:ecomerce_shop_app/views/screens/authencation_screen/login_screen.dart';
import 'package:ecomerce_shop_app/views/screens/authencation_screen/otp_screen.dart';
import 'package:ecomerce_shop_app/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<void> signUpUsers(
      {required context,
      required String fullName,
      required String email,
      required String password}) async {
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

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return OtpScreen(
                email: email,
              );
            }), (route) => false);
            showSnackBar(context, 'Account has been created for you');
          });
    } catch (e) {}
  }

  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode(
            {"email": email, "password": password}), // Create a map here
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () async {
            //Access sharedPreferences for token and user data storage
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            //Extract the authentication token from the response body
            String token = jsonDecode(response.body)['token'];

            //STORE the authentication token securely in sharedPreferences

            preferences.setString('auth_token', token);

            //Encode the user data recived from the backend as json
            final userJson = jsonEncode(jsonDecode(response.body));

            //update the application state with the user data using Riverpod
            ref.read(userProvider.notifier).setUser(response.body);

            //store the data in sharePreference  for future use

            await preferences.setString('user', userJson);

            if (ref.read(userProvider)!.token.isNotEmpty) {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return MainScreen();
              }), (route) => false);
            }
            showSnackBar(context, 'Logged in');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Signout

  Future<void> signOutUser(
      {required BuildContext context, required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //ref.read(orderProvider.notifier).dispose();
      ref.read(userProvider.notifier).signOut();
      ref.read(cartProvider.notifier).signOut();
      ref.read(favoriteProvider.notifier).signOut();
      //ref.read(orderProvider.notifier).signOut();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      showSnackBar(context, 'Signed out successfully');
    } catch (e) {
      showSnackBar(context, "Error signing out");
    }
  }

  //Update user's state, city and locality
  Future<void> updateUserLocation(
      {required context,
      required String id,
      required String state,
      required String city,
      required String locality,
      required WidgetRef ref}) async {
    try {
      //Make an HTTP PUT request to update user's state, city and locality
      final http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        //set the header for the request to specify   that the content  is Json
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
        //Encode the update data(state, city and locality) AS  Json object
        body: jsonEncode({
          'state': state,
          'city': city,
          'locality': locality,
        }),
      );

      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () async {
            //Decode the updated user data from the response body
            //this converts the json String response into Dart Map
            final updatedUser = jsonDecode(response.body);
            //Access Shared preference for local data storage
            //shared preferences allow us to store data persisitently on the the device
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            //Encode the update user data as json String
            //this prepares the data for storage in shared preference
            final userJson = jsonEncode(updatedUser);

            //update the application state with the updated user data  using Riverpod
            //this ensures the app reflects the most recent user data
            ref.read(userProvider.notifier).setUser(userJson);

            //store the updated user data in shared preference  for future user
            //this allows the app to retrive the user data  even after the app restarts
            await preferences.setString('user', userJson);
          });
    } catch (e) {
      //catch any error that occure during the proccess
      //show an error message to the user if the update fails
      showSnackBar(context, 'Error updating location');
    }
  }

//Verify Otp Method
  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/verify-otp'),
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }), (route) => false);
            showSnackBar(context, 'Account verified .Please login.');
          });
    } catch (e) {
      showSnackBar(context, "Error Verifying OT:$e");
    }
  }

  Future<void> resendOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/resend-otp'),
        body: jsonEncode({
          "email": email,
        }),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpRespond(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['msg']);
        },
      );
    } catch (e) {
      showSnackBar(context, 'Có lỗi xảy ra khi gửi lại OTP: $e');
    }
  }

  Future<void> deleteAccount(
      {required BuildContext context,
      required String id,
      required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        showSnackBar(context, 'You need to login to perform this action');
        return;
      }
      http.Response response = await http.delete(
        Uri.parse('$uri/api/user/delete-account/$id'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () async {
            //handle successfull deletion, navigate the user back the the login screen
            //clear user data from sharePreferences
            await preferences.remove('auth_token');
            await preferences.remove('user');
            //clear the user data from the provider state
            ref.read(userProvider.notifier).signOut();
            //Redirect to the login screen after successful deletion
            showSnackBar(context, 'Account deleted successfully');
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }), (route) => false);
          });
    } catch (e) {
      showSnackBar(context, 'Error deleting account $e');
    }
  }

  Future<void> deactivateAccount({
    required BuildContext context,
    required String id,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        showSnackBar(context, 'You need to login to perform this action');
        return;
      }

      http.Response response = await http.put(
        Uri.parse('$uri/api/user/deactivate-account/$id'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      manageHttpRespond(
        response: response,
        context: context,
        onSuccess: () async {
          // Xử lý thành công: chuyển người dùng về màn hình đăng nhập
          await preferences
              .remove('auth_token'); // Xóa token khỏi SharedPreferences
          await preferences
              .remove('user'); // Xóa dữ liệu người dùng khỏi SharedPreferences
          ref
              .read(userProvider.notifier)
              .signOut(); // Xóa dữ liệu người dùng khỏi provider state

          showSnackBar(context, 'Account deactivated successfully');
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          }), (route) => false); // Điều hướng tới màn hình đăng nhập
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error deactivating account: $e');
    }
  }

  getUserData(context, WidgetRef ref) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        preferences.setString('auth_token', '');
      }
      var tokenResponse = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        ref.read(userProvider.notifier).setUser(userResponse.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
