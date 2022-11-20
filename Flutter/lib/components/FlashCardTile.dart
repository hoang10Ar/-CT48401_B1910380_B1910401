import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardAddScreen.dart';
import 'package:flashcard/services/FlashCardService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcard/screens/FlashCardDetailScreen.dart';
import 'package:flashcard/FlashCardDetailArguments.dart';

class FlashCardTile extends StatefulWidget {
  FlashCardTile({super.key, required this.flashCard});

  FlashCard flashCard;

  @override
  State<FlashCardTile> createState() => _FlashCardTileState();
}

class _FlashCardTileState extends State<FlashCardTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          FlashCardDetailScreen.routeName,
          arguments: FlashCardDetailArguments(widget.flashCard.id, false),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(3),
        ),
        child: buildListTile(),
      ),
    );
  }

  Row buildListTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
            child: Text(
              widget.flashCard.word,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        buildListTileIcons(),
      ],
    );
  }

  Row buildListTileIcons() {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.flashCard.isFavoriteListenable,
          builder: (context, isFavorite, child) {
            return IconButton(
              icon: Icon(
                  isFavorite == true ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                widget.flashCard.isFavorite = !isFavorite;

                context
                    .read<FlashCardService>()
                    .toggleFlashCardFavorite(widget.flashCard.id, !isFavorite);
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).pushNamed(FlashCardAddScreen.routeName,
                arguments: widget.flashCard.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Message"),
                content: Text(
                    "Do you want to delete " + widget.flashCard.word + "?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      context
                          .read<FlashCardService>()
                          .deleteFlashCardById(widget.flashCard.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
