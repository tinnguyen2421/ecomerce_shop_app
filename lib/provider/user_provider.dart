import 'package:ecomerce_shop_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  //Constructor initallizing with default User object
  //Purpose :Manage the state of the user object allowing updates
  UserProvider()
      : super(User(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            token: ''));
  //getter method to extract value from an object
  User? get user => state;

  //method to set user state from json
  //purpose: updates the user state base on json String resprestation of user object
  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  //method to clear user state
  void signOut() {
    state = null;
  }

  //Method to Recreate the user state
  void recreatedUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id, //Preserver the existing user id
        fullName: this.state!.fullName, //Preserve the existing user fullname
        email: this.state!.email,
        state: state,
        city: city,
        locality: locality,
        password: this.state!.password,
        token: this.state!.token,
      );
    }
  }

  //make the data accisible within the application
  final userProvider =
      StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
}
