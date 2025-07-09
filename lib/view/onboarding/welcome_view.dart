import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.height / 812; // Base height (iPhone 11 Pro)
    double padding = 15 * scale;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/image/welcome_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),

          // Foreground Content
          SafeArea(
            child: Container(
              width: media.width,
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.height * 0.1 ),

                  // Welcome Title
                  Text(
                    "Book For\nEvery Taste.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Tcolor.primartLight,
                      fontSize: 36 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: media.height * 0.10),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50 * scale,
                    child: MaterialButton(
                      onPressed: () {
                        // TODO: Navigate to Sign In
                      },
                      color: Tcolor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20 * scale),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 17 * scale,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20 * scale),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50 * scale,
                    child: MaterialButton(
                      onPressed: () {
                        // TODO: Navigate to Sign Up
                      },
                      color: Tcolor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20 * scale),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 17 * scale,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
