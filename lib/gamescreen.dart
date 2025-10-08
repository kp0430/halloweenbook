import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _gameWon = false;
  final Random _random = Random();

  // Example spooky items
  final List<Map<String, dynamic>> spookyItems = [
    {'image': 'assets/images/ghost.png', 'isTrap': true},
    {'image': 'assets/images/pumpkin.png', 'isTrap': false}, // WIN ITEM
    {'image': 'assets/images/bat.png', 'isTrap': true},
    {'image': 'assets/images/candy.png', 'isTrap': true},
  ];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);

    // Play looping background music
    _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _bgPlayer.play(AssetSource('sounds/background.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  void _onItemTap(bool isTrap) async {
    if (_gameWon) return;

    if (isTrap) {
      await _sfxPlayer.play(AssetSource('sounds/jumpscare.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BOO! You clicked a trap! 👻'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      setState(() => _gameWon = true);
      await _sfxPlayer.play(AssetSource('sounds/win.mp3'));
    }
  }

  Widget _buildSpookyItem(Map<String, dynamic> item, int index) {
    final double randomX = _random.nextDouble() * 250;
    final double randomY = _random.nextDouble() * 400;
    final double randomScale = 0.5 + _random.nextDouble() * 0.8;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double dx = randomX + sin(_controller.value * 2 * pi) * 20;
        double dy = randomY + cos(_controller.value * 2 * pi) * 20;

        return Positioned(
          left: dx,
          top: dy,
          child: Transform.scale(
            scale: randomScale,
            child: IconButton(
              onPressed: () => _onItemTap(item['isTrap']),
              iconSize: 80,
              icon: Image.asset(item['image']),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Spooky Hunt"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: Stack(
        children: [
          ...List.generate(spookyItems.length,
              (index) => _buildSpookyItem(spookyItems[index], index)),
          if (_gameWon)
            Center(
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "🎉 You Found It! 🎃",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
