import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_api/screens/auth_screens/login_screen.dart'; // <- импорт твоей Login страницы
import 'package:nutrition_api/screens/auth_screens/welcome_screen.dart';
import 'package:logger/logger.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _initVerification();
  }

  Future<void> _initVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    try {
      await user.reload();
      isEmailVerified = user.emailVerified;
    } catch (e) {
      logger.e('Error reloading user: $e');
    }

    if (isEmailVerified) {
      _goToLogin();
      return;
    }

    await sendVerificationEmail();

    timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _checkEmailVerified() {
    if (!mounted) {
      timer?.cancel();
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      timer?.cancel();
      return;
    }

    user.reload().then((_) {
      final verified = user.emailVerified;

      if (!mounted) return;

      setState(() => isEmailVerified = verified);

      if (verified) {
        timer?.cancel();
        _goToLogin();
      }
    }).catchError((e) {
      logger.e('Error checking email verification: $e');
    });
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await user.sendEmailVerification();

      if (!mounted) return;
      setState(() => canResendEmail = false);

      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return;
      setState(() => canResendEmail = true);
    } catch (e) {
      logger.e('Error sending email: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send email')),
      );
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()), // <- здесь Login page
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D8194),
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email_outlined, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'A confirmation email has been sent. Please check your email.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (!isEmailVerified) const CircularProgressIndicator(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  child: const Text('Resend email'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    );
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
