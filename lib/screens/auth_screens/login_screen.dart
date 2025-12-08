import 'package:email_validator/email_validator.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF70B9BE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF70B9BE),
        title: Text('Log In'),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
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
                    if(v == null || v.isEmpty){
                      return 'Password cannot be empty';
                    }else if(v.length<6){
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  isHiddenPassword: isHiddenPassword,
                  togglePasswordView: togglePasswordView,
                ),
                const SizedBox(height: 30),
                CustomElevatedButton(
                  onTap: (){
                    if(!_formKey.currentState!.validate()) return;
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const BottomNavigationScreens())
                    );
                  } 
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}