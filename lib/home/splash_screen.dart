import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: screenSize.width / (screenSize.height / 3),
                child: Image.asset(
                  'assets/app_icon.png',
                ),
              ),
              const SizedBox(height: 32.0),
              Image.asset(
                'assets/app_title.png',
                width: screenSize.width / 1.25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
