import 'package:flutter/material.dart';
import 'package:flutter_chat/new_screens/auth_screen.dart';
import 'package:flutter_chat/new_screens/profile_screen.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> _pages = [
      PageViewModel(
        titleWidget: const Text('Connect', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        body: 'A social media app where you can meet new people and connect with them',
        image: Image.asset('assets/images/onboard1.png')
      ),
      PageViewModel(
          titleWidget: const Text('Socialise', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        body: 'Enter a new world of social bees, from the palm of your hand',
        image: Image.asset('assets/images/onboard2.png')
      ),
      PageViewModel(
          titleWidget: const Text('Grow', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        body: 'Meet like minded people, share ideas, and grow. Your network is your net-worth',
        image: Image.asset('assets/images/onboard3.png')
      ),
    ];

    return IntroductionScreen(
      showNextButton: true,
      next: const Text('Next'),
      showSkipButton: true,
      skip: const Text('Skip'),
      pages: _pages,
      done: const Text('Done'),
      onDone: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const AuthroizationScreen()), (route) => false);
      },
      onSkip: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const AuthroizationScreen()), (route) => false);
      },
    );
  }
}
