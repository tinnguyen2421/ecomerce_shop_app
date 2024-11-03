import 'package:ecomerce_shop_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _localityController;
  @override
  void initState() {
    super.initState();
    //read the current user data from the provider
    final user = ref.read(userProvider);
    //initialize the controllers with the current data if available
    //if the user data is not available, initalize with an empty String
    _stateController = TextEditingController(text: user?.state ?? "");
    _cityController = TextEditingController(text: user?.city ?? "");
    _localityController = TextEditingController(text: user?.locality ?? "");
  }

  //show load ing dialog
  _showLoadingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(
                15,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Updating...',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updatedUser = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.96),
        elevation: 0,
        title: Text(
          'Delivery',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            letterSpacing: 1.7,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'where will your order \n be shipped',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  controller: _stateController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter State';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'State',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _cityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter City';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _localityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Locality';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Locality',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _showLoadingDialog();
              await _authController
                  .updateUserLocation(
                context: context,
                id: user!.id,
                state: _stateController.text,
                city: _cityController.text,
                locality: _localityController.text,
              )
                  .whenComplete(() {
                updatedUser.recreatedUserState(
                  state: _stateController.text,
                  city: _cityController.text,
                  locality: _localityController.text,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } else {
              print('Not Valid');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF3854EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
