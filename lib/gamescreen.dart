import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
class HauntedForestPage extends StatefulWidget {
  const HauntedForestPage({Key? key}) : super(key: key);

  @override
  _HauntedForestPageState createState() => _HauntedForestPageState();
}

class _HauntedForestPageState extends State<HauntedForestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haunted Forest'),
      ),
      body: const Center(
        child: Text('Welcome to the Haunted Forest!'),
      ),
    );
  }
}