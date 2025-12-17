import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_api/screens/auth_screens/widgets/custom_elevated_button.dart';
import 'package:nutrition_api/screens/auth_screens/widgets/custom_text_field.dart';
import 'package:nutrition_api/screens/home_screens/bottom_navigation_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF70B9BE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF70B9BE),
        title: Text('Log In'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                      ? 'Input correct email'
                      : null,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password cannot be empty';
                    } else if (v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  isHiddenPassword: isHiddenPassword,
                  togglePasswordView: togglePasswordView,
                ),
                const SizedBox(height: 30),
                CustomElevatedButton(
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;

                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BottomNavigationScreens(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      String errorMessage;

                      switch (e.code) {
                        case 'invalid-email':
                          errorMessage = 'The email address is not valid.';
                          break;
                        case 'user-disabled':
                          errorMessage = 'This user has been disabled.';
                          break;
                        case 'user-not-found':
                          errorMessage = 'No user found for this email.';
                          break;
                        case 'wrong-password':
                          errorMessage = 'Incorrect password. Try again.';
                          break;
                        case 'too-many-requests':
                          errorMessage = 'Too many attempts. Try again later.';
                          break;
                        default:
                          errorMessage = 'Login error. Please try again.';
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMessage)));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
