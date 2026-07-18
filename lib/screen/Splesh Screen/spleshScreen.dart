import 'package:flutter/material.dart';

class Spleshscreen extends StatelessWidget {
  const Spleshscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/icons/spleshScreen_image.png")
        ],
      ),
    );
  }
}