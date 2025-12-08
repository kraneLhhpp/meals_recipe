import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final bool? isHiddenPassword;
  final VoidCallback? togglePasswordView;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key, 
    required this.hintText, 
    required this.controller, 
    this.validator, 
    this.obscure = false, 
    this.isHiddenPassword, 
    this.togglePasswordView, 
    this.onChanged, 
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure && (isHiddenPassword ?? false),
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: obscure && togglePasswordView != null
          ? InkWell(
            onTap: togglePasswordView,
            child: Icon(
              isHiddenPassword! ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ) 
          : null,
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFF009688),
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: borderType(true),
        focusedBorder: borderType(false),
        errorBorder: borderType(false),
        focusedErrorBorder: borderType(false)
      ),
    );
  }

  OutlineInputBorder borderType(bool isEnabled) {
    return OutlineInputBorder(
        borderRadius:  BorderRadius.circular(20),
        borderSide: isEnabled ? BorderSide(color: Colors.white) : BorderSide(color: const Color(0xFF2E7D32)),
      );
  }
}