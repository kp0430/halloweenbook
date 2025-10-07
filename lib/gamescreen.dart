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
