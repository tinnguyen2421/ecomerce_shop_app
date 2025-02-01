import 'package:ecomerce_shop_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import Timer

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isResendVisible = true; // To control visibility of "Resend" button
  int countdownTime = 60; // Countdown timer in seconds
  late Timer _timer; // Timer to handle countdown

  final AuthController _authController = AuthController();
  List<String> otpDigits = List.filled(6, '');

  // Function to start the countdown timer
  // Function to start the countdown timer
  void startCountdown() {
    setState(() {
      isResendVisible = false; // Hide resend button
      countdownTime = 60; // Reset countdown to 60 seconds each time
    });

    // Cancel any existing countdown before starting a new one
    _timer.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTime == 0) {
        _timer.cancel();
        setState(() {
          isResendVisible = true; // Show resend button when countdown ends
        });
      } else {
        setState(() {
          countdownTime--;
        });
      }
    });
  }

  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    final otp = otpDigits.join(); // Combine digits into a single OTP String
    print("OTP entered by user: $otp");
    await _authController
        .verifyOtp(context: context, email: widget.email, otp: otp)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        // Handles changes in the text input.
        onChanged: (value) {
          if (value.isNotEmpty && value.length == 1) {
            otpDigits[index] = value;

            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          }
        },
        onFieldSubmitted: (value) {
          if (index == 5 && _formKey.currentState!.validate()) {
            verifyOtp();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Verify Your Account",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: const Color(0xFF0d120E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the OTP sent to ${widget.email}",
                    style: GoogleFonts.lato(
                      color: Color(0),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, buildOtpField),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "Didn't receive the OTP code?" Text
                      Text(
                        "Didn't receive the code?",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8), // Add space between texts
                      // Conditional Text for countdown or resend button
                      isResendVisible
                          ? InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await _authController.resendOtp(
                                    context: context, email: widget.email);
                                setState(() {
                                  isLoading = false;
                                });
                                startCountdown(); // Start countdown after resend
                              },
                              child: Text(
                                'Resend',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF103DE5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Text(
                              'Please wait $countdownTime seconds to resend.',
                              style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      verifyOtp();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF103DE5),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Verify',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
