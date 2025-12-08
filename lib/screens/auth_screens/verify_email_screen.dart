import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_api/screens/auth_screens/welcome_screen.dart';
import 'package:nutrition_api/screens/home_screens/home_bar.dart';
import 'package:logger/logger.dart';


class VerifyEmailScreen extends StatefulWidget {

  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailScreen> {
  Timer? timer; 
  bool isEmailVerified  = false;
  bool canResendEmail = false;
  final logger = Logger();


  @override
  void initState() {
    super.initState();
  }

  Future<void> initVerification()async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      if(mounted) Navigator.pop(context);
      return;
    }
    isEmailVerified = user.emailVerified;

    if(!isEmailVerified){
      await sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 4), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified()async{
    final user = FirebaseAuth.instance.currentUser;

    if(user == null){
      timer?.cancel();
      return;
    }

    await user.reload();
    final verified = user.emailVerified;

    if(!mounted)return;

    setState(() {
      isEmailVerified = verified;
    });

    if(verified){
      timer?.cancel();
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const HomeBar())
      );
    }
  }

  Future<void> sendVerificationEmail()async{
    try{
      final user = FirebaseAuth.instance.currentUser;

      if(user == null)return;

      await user.sendEmailVerification();

      if(!mounted)return;

      setState(() {
        canResendEmail = false;
      });

      if(!mounted)return;

      setState(() {
        canResendEmail=true;
      });
    }catch (e){
      logger.e('Error sending email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send Email'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D8194),
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SafeArea(
        child:  Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Icon(Icons.email_outlined),
                const SizedBox(height: 20),
                const Text(
                  'A confirmation email has been sent. Please check your email.'
                ),
                const SizedBox(height: 20),
                if(!isEmailVerified) const CircularProgressIndicator(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: canResendEmail ? sendVerificationEmail : null, 
                  child: const Text('Resend email')
                ),
                const  SizedBox(height: 15),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const WelcomeScreen(),) 
                    );
                  }, 
                  child: const Text('Back')
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}