import 'package:flutter/material.dart';
import 'package:flutter_app/view/onboarding/onboarding_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'SF Pro Text',
     ),
      home: const OnboardingView(),
    );
  }
}
