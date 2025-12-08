import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomElevatedButton({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        backgroundColor: Colors.black
      ),
      onPressed: onTap, 
      child: const Text('Login',style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}