import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardAddScreen.dart';
import 'package:flashcard/screens/FlashCardPlayScreen.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCardDetailScreen extends StatefulWidget {
  const FlashCardDetailScreen(this.flashCard, this.isRandom, {super.key});

  final FlashCard flashCard;
  final bool isRandom;
  static const routeName = '/flashcard-detail';

  @override
  State<FlashCardDetailScreen> createState() => _FlashCardDetailScreenState();
}

class _FlashCardDetailScreenState extends State<FlashCardDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlashCard's Detail"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.blue[200],
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: const Text('Word:', style: TextStyle(fontSize: 30)),
          ),
          Container(
            color: const Color.fromARGB(255, 166, 156, 160),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.flashCard.word,
                style: const TextStyle(fontSize: 80, color: Colors.yellow),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text('Meaning:', style: TextStyle(fontSize: 30)),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            color: const Color.fromARGB(255, 166, 163, 156),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.flashCard.meaning,
                style: const TextStyle(fontSize: 50, color: Colors.yellow),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text('Example:', style: TextStyle(fontSize: 30)),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            color: const Color.fromARGB(255, 166, 163, 156),
            child: Text(
              widget.flashCard.example ?? "",
              style: const TextStyle(fontSize: 35, color: Colors.yellow),
            ),
          ),
          const SizedBox(height: 10),
          widget.isRandom
              ? TextButton(
                  child: const Text("Next word ->",
                      style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(FlashCardPlayScreen.routeName);
                  },
                )
              : TextButton(
                  child: const Text('Update', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      FlashCardAddScreen.routeName,
                      arguments: widget.flashCard.id,
                    );
                  },
                ),
          const SizedBox(height: 10, width: double.infinity),
          buildButtonSearchMeaningOnline(),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  TextButton buildButtonSearchMeaningOnline() {
    return TextButton(
      onPressed: () async {
        String? meaning = await context
            .read<FlashCardService>()
            .searchMeaningOnline(widget.flashCard.word);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Search meaning online"),
            content: Text(
                widget.flashCard.word + ": " + (meaning ?? "Not Found! :(")),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },
      child: const Text(
        'Search meaning online',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.flashCard.isFavoriteListenable,
      builder: (context, isFavorite, child) {
        return FloatingActionButton.large(
          backgroundColor: isFavorite == true ? Colors.red[200] : Colors.white,
          child: Icon(
            isFavorite == true ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 50,
          ),
          onPressed: () {
            widget.flashCard.isFavorite = !isFavorite;

            context
                .read<FlashCardService>()
                .toggleFlashCardFavorite(widget.flashCard.id, !isFavorite);
          },
        );
      },
    );
  }
}
