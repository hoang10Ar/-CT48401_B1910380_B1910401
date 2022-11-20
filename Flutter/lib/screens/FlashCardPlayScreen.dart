import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardDetailScreen.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flashcard/FlashCardDetailArguments.dart';

class FlashCardPlayScreen extends StatefulWidget {
  const FlashCardPlayScreen({super.key});

  static const routeName = '/flashcard-play';

  @override
  State<FlashCardPlayScreen> createState() => _FlashCardPlayScreenState();
}

class _FlashCardPlayScreenState extends State<FlashCardPlayScreen> {
  FlashCard? flashCard;

  @override
  void initState() {
    super.initState();

    FlashCardService flashCardService = context.read<FlashCardService>();
    flashCard = flashCardService
        .getFlashCardByIndex(Random().nextInt(flashCardService.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.blue[200],
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: const Text('Word:', style: TextStyle(fontSize: 40)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                flashCard?.word ?? "",
                style: const TextStyle(fontSize: 90, color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(
                FlashCardDetailScreen.routeName,
                arguments: FlashCardDetailArguments(flashCard?.id ?? "", true),
              );
            },
            child: const Text('Show meaning', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
