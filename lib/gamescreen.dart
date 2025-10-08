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

  final List<Map<String, dynamic>> spookyItems = [
    {'image': 'assets/images/ghost.jpeg', 'isTrap': true},
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

    _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _bgPlayer.setVolume(1.0);
    _sfxPlayer.setVolume(1.0);

    // Start background music
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _bgPlayer.play(AssetSource('sounds/BgMusic.mp3'));
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BOO! You clicked a trap! 👻'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      setState(() => _gameWon = true);
      await _sfxPlayer.play(AssetSource('sounds/success.mp3'));
    }
  }

  void _resetGame() {
    setState(() {
      _gameWon = false;
    });
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
              icon: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spooky Hunt"),
        backgroundColor: Colors.deepPurple.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Floating spooky items
          ...List.generate(
              spookyItems.length, (index) => _buildSpookyItem(spookyItems[index], index)),

          // Win overlay
          if (_gameWon)
            Center(
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🎉 You Found It! 🎃",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        "Play Again",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
