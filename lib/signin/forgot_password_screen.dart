import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  String? _message;
  bool _isLoading = false;

  /// Computed property that checks if the form is valid.
  bool get _isFormValid =>
      _emailController.text.isNotEmpty && _isValidEmail(_emailController.text);

  /// Validates the email format using a regex pattern.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Sends a password reset email using Firebase Auth.
  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _emailError = null;
      _message = null;
    });

    final email = _emailController.text.trim();

    // Validate email input
    if (email.isEmpty || !_isValidEmail(email)) {
      setState(() {
        _emailError = "Please enter a valid email address.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message =
            "A password reset email has been sent to $email. Please check your inbox.";
      });
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      String errorMsg;
      switch (e.code) {
        case 'user-not-found':
          errorMsg = "No user found for that email.";
          break;
        default:
          errorMsg = "Error: ${e.message}";
      }
      setState(() {
        _message = errorMsg;
      });
    } catch (e) {
      setState(() {
        _message = "An unexpected error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Enter your email to receive a password reset link",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                errorText: _emailError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {
                setState(() {}); // Update UI to reflect form validity
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? Colors.black : const Color(0xFFA0A0A0),
                    foregroundColor:
                        Colors.white, // Button text color set to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _isFormValid ? _sendPasswordResetEmail : null,
                  child: const Text("Send Password Reset Email"),
                ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _message!.contains("sent") ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
