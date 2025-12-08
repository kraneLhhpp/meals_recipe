import 'package:flutter/material.dart';
import 'package:nutrition_api/screens/auth_screens/login_screen.dart';
import 'package:nutrition_api/screens/auth_screens/sign_up_screen.dart';
import 'package:nutrition_api/screens/auth_screens/widgets/custom_elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF70B9BE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.08),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _logoImage('ws_logo1'),
                    _logoImage('ws_logo2'),
                    _logoImage('ws_logo3'),
                    _logoImage('we_logo4'),
                    _logoImage('ws_logo5'),
                    _logoImage('ws_logo6'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.015),
              const Text(
                'Help your path to health goals with happiness', 
                maxLines: 2, 
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) =>  const LoginScreen(),)
                  );
                } 
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const SignUpScreen())
                  );
                }, 
                child: const Text('Create New Account', style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _logoImage(String imagePath){
    return ClipRRect(
      child: Container(
        color: const Color(0xFF70B9BE),
        child: Image.asset(
          'assets/images/ws/$imagePath.png', fit: BoxFit.contain,)
      )
    );
  }
}

