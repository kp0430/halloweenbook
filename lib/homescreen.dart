import 'package:flutter/material.dart';
import 'gamescreen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🎃 Kevin's Haunted Forest 🎃",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1500),
                    pageBuilder: (_, animation, __) => const GameScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: const Text(
                "Enter the Haunted Forest... if you dare!",
                style: TextStyle(fontSize: 19, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}