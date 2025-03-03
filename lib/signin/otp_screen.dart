import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart'; // Required for input formatting

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  String enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Set the entire background to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
              ), // ✅ Same left padding as email
              child: const Text(
                "Enter Code",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: const Text(
                "We’ve sent an email with an OTP to email:",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: const Text(
                "youremail@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: (62 * 5) + (8 * 4), // Ensuring correct width calculation
                child: PinCodeTextField(
                  appContext: context,
                  length: 5, // 5 OTP boxes
                  obscureText: false,
                  animationType: AnimationType.fade,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Adds spacing
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(13), // Rounded corners
                    fieldHeight: 76, // Box Height
                    fieldWidth: 62, // Box Width
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white, // Keep inside white
                    selectedFillColor: Colors.white,
                    inactiveColor: Color(0xFFD1D1D1),
                    selectedColor: Colors.black,
                    activeColor: Colors.black,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: otpController,
                  keyboardType: TextInputType.number, // Ensure number keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ], // Only allow digits
                  onChanged: (value) {
                    setState(() {
                      enteredOtp = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "didn’t receive the code? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8D8D8D), // Light grey
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Resend OTP action
                    },
                    splashColor: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Smooth ripple edges
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111), // Dark grey/black color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 343,
                height: 59,
                child: ElevatedButton(
                  onPressed:
                      enteredOtp.length == 5
                          ? () {
                            // Verify OTP action
                          }
                          : null, // Disable button if OTP is incomplete
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        enteredOtp.length == 5
                            ? Colors
                                .black // Enabled Black
                            : Color(0xFFD1D1D1), // Disabled Grey (D1D1D1)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
