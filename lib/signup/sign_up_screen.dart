import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isFormValid = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;
  String? _passwordError;
  bool _isEmailValid = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(() {
      _validateEmail();
      _validateForm();
    });
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    _validatePassword();

    setState(() {
      _isFormValid =
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _isEmailValid &&
          _passwordError == null;
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    setState(() {
      _isEmailValid = email.isEmpty || emailRegex.hasMatch(email);
      _emailError = _isEmailValid ? null : "Please enter a valid email address";
    });
  }

  void _validatePassword() {
    if (_passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      _passwordError = "Passwords do not match";
    } else {
      _passwordError = null;
    }
  }

  Future<void> _onSubmit() async {
    _validateForm();

    if (!_isFormValid) return;

    try {
      // 1. Create user with email/password
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // 2. Save additional user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'Mother', // Default role, can be updated later
        'child': {}, // Empty child object for now
      });

      // 3. Navigate to baby registration screen
      Navigator.pushNamed(context, '/baby-registration');
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email already in use.";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak.";
          break;
        default:
          errorMessage = "Signup failed. Please try again.";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An unexpected error occurred.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tell us about you",
                        style: TextStyle(
                          fontFamily: 'InterTight',
                          fontSize: 32.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Every detail helps us support your baby’s journey.",
                        style: TextStyle(
                          fontFamily: 'InterTight',
                          fontSize: 17.2,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF8D8D8D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLabeledTextField(
                        "Enter Your Name",
                        "First Name",
                        _firstNameController,
                      ),
                      const SizedBox(height: 14),
                      _buildLabeledTextField(
                        "",
                        "Last Name",
                        _lastNameController,
                      ),
                      const SizedBox(height: 14),
                      _buildLabeledTextField(
                        "Enter Your Email",
                        "example@email.com",
                        _emailController,
                        errorText: _isEmailValid ? null : _emailError,
                        svgIconPath: "assets/images/email.svg",
                      ),
                      const SizedBox(height: 14),
                      _buildLabeledTextField(
                        "Create a Strong Password",
                        "Enter a password",
                        _passwordController,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        svgIconPath: "assets/images/pw.svg",
                      ),
                      const SizedBox(height: 14),
                      _buildLabeledTextField(
                        "",
                        "Re-enter the password",
                        _confirmPasswordController,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        errorText: _passwordError,
                        svgIconPath: "assets/images/pw.svg",
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "We collect this info to personalize activities and track growth. Your data is secure and used only to enhance your experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InterTight',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF938E8A),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid
                            ? const Color(0xFF111111)
                            : Colors.grey.shade400,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'InterTight',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabeledTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? togglePasswordVisibility,
    String? errorText,
    String? svgIconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'InterTight',
              fontSize: 14.82,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
            ), // Placeholder text color changed
            errorText: errorText,
            prefixIcon:
                svgIconPath != null
                    ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        svgIconPath,
                        height: 20,
                        width: 20,
                      ),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
