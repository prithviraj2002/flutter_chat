import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat/new_screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'assets/images/splash.gif',
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: const [
                FadeEffect(duration: Duration(seconds: 5))
              ],
              onComplete: (controller){
                if(controller.isCompleted){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()), (route) => false);
                }
              },
              child: const Text('Social Bee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
            )
          ],
        ),
      ),
    );
  }
}
