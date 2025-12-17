import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_api/screens/auth_screens/verify_email_screen.dart';
import 'package:nutrition_api/screens/auth_screens/widgets/custom_elevated_button.dart';
import 'package:nutrition_api/screens/auth_screens/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF70B9BE),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF70B9BE),
        title: Text('Sign Up'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'First Name',
                  controller: _fNameController,
                  validator: (v) => v!.isEmpty ? "Field cannot be empty" : null,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Last Name',
                  controller: _lNameController,
                  validator: (v) => v!.isEmpty ? "Field cannot be empty" : null,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _phoneController,
                  validator: (v) =>
                      v!.isEmpty ? 'Phone Number cannot be empty' : null,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
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
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                      final user = credential.user;

                      if (user != null) {
                        await user.updateDisplayName(
                          '${_fNameController.text.trim()} ${_lNameController.text.trim()}',
                        );
                        await user.reload();
                      }

                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifyEmailScreen(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Sign up error')),
                      );
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
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
