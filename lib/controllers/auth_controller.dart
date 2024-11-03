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

  //Update user's state ,city and locality
  Future<void> updateUserLocation(
      {required context,
      required String id,
      required String state,
      required String city,
      required String locality}) async {
    try {
      //Make an HTTP PUT request to update user's state, city, locality
      http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        //set the header for the request to specify that the content is json
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        //Encode the update data(state, city and locality) as Json object
        body: jsonEncode(
          {
            'state': state,
            'city': city,
            'locality': locality,
          },
        ),
      );
      manageHttpRespond(
        response: response,
        context: context,
        onSuccess: () async {
          //Decode the updated user data from the response body
          //this coverts the json String response into Dart Map
          final updatedUser = jsonDecode(response.body);
          //Access shared preference for local data storage
          //shared preferences allow us to store data persisitently on the divice
          SharedPreferences preferences = await SharedPreferences.getInstance();
          //Encode the update user data as json String
          //this prepares the data for storage in sharePreference
          final userJson = jsonEncode(updatedUser);
          //updated the application state with the updated user data user in RiverPod
          //this ensures the app reflects the most recent user data
          providerContainer.read(userProvider.notifier).setUser(userJson);
          //store the updated user data in shared preference for future user
          //this allow the app to retrive the user data even after the app restarts
          await preferences.setString('user', userJson);
        },
      );
    } catch (e) {
      //catch any error that occure during the proccess
      //show an error message to the user if the update fails
      showSnackBar(context, 'Erro updating location');
    }
  }
}
