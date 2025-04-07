import 'package:flutter/material.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/otpverification.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:flutter_app/pages/loginpage.dart';
import 'package:flutter_app/pages/onboardingpage.dart';

void main() {
  runApp(const MyApp());
  }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpVerificationScreen(phoneNumber: ""),
        '/home': (context) => const Homepage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
      
      
    );
  }
}