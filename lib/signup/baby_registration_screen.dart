import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BabyRegistrationScreen extends StatefulWidget {
  const BabyRegistrationScreen({super.key});

  @override
  _BabyRegistrationScreenState createState() => _BabyRegistrationScreenState();
}

class _BabyRegistrationScreenState extends State<BabyRegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _birthWeightController = TextEditingController();
  final TextEditingController _birthHeightController = TextEditingController();
  final TextEditingController _currentWeightController =
      TextEditingController();
  final TextEditingController _currentHeightController =
      TextEditingController();

  String? _selectedGender;
  bool _isFormValid = false;
  bool _isTodayDob = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _dobController.addListener(_validateForm);
    _birthWeightController.addListener(_validateForm);
    _birthHeightController.addListener(_validateForm);
    _currentWeightController.addListener(_validateForm);
    _currentHeightController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _birthWeightController.text.isNotEmpty &&
          _birthHeightController.text.isNotEmpty &&
          (_isTodayDob ||
              (_currentWeightController.text.isNotEmpty &&
                  _currentHeightController.text.isNotEmpty)) &&
          _selectedGender != null;
    });
  }

  void _onDateSelected(DateTime pickedDate) {
    DateTime today = DateTime.now();
    bool isToday =
        pickedDate.year == today.year &&
        pickedDate.month == today.month &&
        pickedDate.day == today.day;

    setState(() {
      _dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      _isTodayDob = isToday;

      if (isToday) {
        _currentWeightController.clear();
        _currentHeightController.clear();
      }
    });

    _validateForm();
  }

  Future<void> _onSubmit() async {
    if (!_isFormValid) return;

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      // Save baby data to Firestore
      await _firestore.collection('users').doc(userId).update({
        'child': {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'dob': _dobController.text.trim(),
          'gender': _selectedGender,
          'birthWeight': double.parse(_birthWeightController.text.trim()),
          'birthHeight': double.parse(_birthHeightController.text.trim()),
          'currentWeight':
              _isTodayDob
                  ? null
                  : double.parse(_currentWeightController.text.trim()),
          'currentHeight':
              _isTodayDob
                  ? null
                  : double.parse(_currentHeightController.text.trim()),
        },
      });

      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save baby data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Tell us about your baby",
              style: TextStyle(
                fontSize: 32.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Every detail helps us support your baby’s journey.",
              style: TextStyle(
                fontSize: 17.2,
                fontWeight: FontWeight.w300,
                color: Color(0xFF8D8D8D),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabeledTextField(
              "Enter Your Baby’s Name",
              "First Name",
              _firstNameController,
            ),
            const SizedBox(height: 10),
            _buildLabeledTextField("", "Last Name", _lastNameController),
            const SizedBox(height: 10),
            _buildLabeledTextField(
              "Date of Birth",
              "dd/mm/yyyy",
              _dobController,
              isDate: true,
            ),
            const SizedBox(height: 10),
            _buildGenderDropdown(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledTextField(
                    "Birth Weight",
                    "Weight",
                    _birthWeightController,
                    suffix: "kg",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildLabeledTextField(
                    "Birth Height",
                    "Height",
                    _birthHeightController,
                    suffix: "cm",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledTextField(
                    "Current Weight",
                    "Weight",
                    _currentWeightController,
                    suffix: "kg",
                    isDisabled: _isTodayDob,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildLabeledTextField(
                    "Current Height",
                    "Height",
                    _currentHeightController,
                    suffix: "cm",
                    isDisabled: _isTodayDob,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "We collect this info to personalize activities and track growth. Your data is secure and used only to enhance your experience.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF938E8A)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isDate = false,
    String? suffix,
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.82,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: isDate || isDisabled,
          enabled: !isDisabled,
          style: TextStyle(
            color:
                controller.text.isNotEmpty ? Colors.black : Color(0xFFC5C5C5),
          ),
          keyboardType:
              isDate
                  ? TextInputType.datetime
                  : (suffix != null
                      ? TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text),
          inputFormatters:
              suffix != null
                  ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
                  : [],
          onTap:
              isDate
                  ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _onDateSelected(pickedDate);
                    }
                  }
                  : null,
          decoration: _inputDecoration(hint, suffix, isDisabled),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      hint: const Text("Gender"),
      items:
          ["Male", "Female", "Other"]
              .map(
                (gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
          _validateForm();
        });
      },
      decoration: _inputDecoration(null, null, false),
    );
  }

  InputDecoration _inputDecoration(
    String? hint,
    String? suffix,
    bool isDisabled,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: isDisabled ? Colors.grey.shade300 : Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFC5C5C5)),
      suffixText: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }
}
