import 'package:flutter/material.dart';
import 'package:medication_tracker/pages/home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isLoginEnabled = true; // Flag to control the login button

  // Email validation using regex
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'; // Email regex pattern
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  // Go to home page after successful login
  void goToHomePage() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 181, 195, 217),
            Color.fromARGB(255, 121, 141, 174)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Form(
          key: _formKey, // Assign form key to validate inputs
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50),
              _inputField("Email", usernameController, _validateEmail),
              const SizedBox(height: 20),
              _inputField("Password", passwordController, _validatePassword,
                  isPassword: true),
              const SizedBox(height: 50),
              _loginBtn()
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  Widget _inputField(
    String hintText,
    TextEditingController controller,
    String? Function(String?) validator, {
    bool isPassword = false,
  }) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ), // Error border with red color
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      obscureText: isPassword,
      validator: validator, // Assign validation function
      keyboardType: TextInputType.text
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: _isLoginEnabled
          ? () {
              if (_formKey.currentState!.validate()) {
                debugPrint("Email : ${usernameController.text}");
                debugPrint("Password : ${passwordController.text}");
                goToHomePage();
              }
            }
          : null, // Disable button if validation fails
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Sign in",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 70, 94, 123)
          ),
        ),
      ),
    );
  }
}
