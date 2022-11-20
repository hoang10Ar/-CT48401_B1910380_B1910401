import 'package:flutter/material.dart';

class FlashCard {
  String id;
  String word;
  String meaning;
  String? example;
  final ValueNotifier<bool> _isFavorite;

  FlashCard({
    required this.id,
    required this.word,
    required this.meaning,
    this.example,
    isFavorite,
  }) : _isFavorite = ValueNotifier(isFavorite);

  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'example': example,
      'isFavorite': isFavorite,
    };
  }

  static FlashCard fromJson(Map<String, dynamic> json) {
    return FlashCard(
      id: json['id'].toString(),
      word: json['word'],
      meaning: json['meaning'],
      example: json['example'],
      isFavorite: json['isFavorite'],
    );
  }

  static List<FlashCard> fromListJson(List<dynamic> jsons) {
    return jsons.map((json) => FlashCard.fromJson(json)).toList();
  }
}
