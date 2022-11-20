import 'dart:io';
import 'package:flashcard/models/AuthLogin.dart';
import 'package:flashcard/models/FlashCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlashCardService with ChangeNotifier {
  String backendUrl = "http://10.0.2.2:3000";
  List<FlashCard> flashCards = [];

  Future<List<FlashCard>> fetchFlashCards() async {
    try {
      String url =
          backendUrl + "/api/flashCard?email=" + (AuthLogin.email ?? '');
      Uri uri = Uri.parse(url);

      var res = await http.get(uri);
      flashCards =
          FlashCard.fromListJson(jsonDecode(res.body) as List<dynamic>);
    } catch (error) {
      flashCards = [];
    }

    return flashCards;
  }

  Future<List<FlashCard>> fetchFlashCardsFavorited() async {
    try {
      String url = backendUrl +
          "/api/flashCard/favorite?email=" +
          (AuthLogin.email ?? '');
      Uri uri = Uri.parse(url);

      var res = await http.get(uri);
      flashCards =
          FlashCard.fromListJson(jsonDecode(res.body) as List<dynamic>);
    } catch (error) {
      flashCards = [];
    }

    return flashCards;
  }

  int get length {
    return flashCards.length;
  }

  FlashCard getFlashCardByIndex(int index) {
    return flashCards[index];
  }

  FlashCard? getFlashCardById(String id) {
    return flashCards.firstWhere((flashCard) => flashCard.id == id);
  }

  void deleteFlashCardById(String id) async {
    String url = backendUrl + "/api/flashCard/" + id;
    Uri uri = Uri.parse(url);

    await http.delete(uri);

    flashCards.removeWhere((flashCard) => flashCard.id == id);
    notifyListeners();
  }

  void addFlashCard(FlashCard flashCard) async {
    String url = backendUrl + "/api/flashCard?email=" + (AuthLogin.email ?? '');
    Uri uri = Uri.parse(url);

    final flashCardJson = await http.post(
      uri,
      body: json.encode(flashCard.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    FlashCard flashCardResponse = FlashCard.fromJson(
        json.decode(flashCardJson.body) as Map<String, dynamic>);
    flashCards.add(flashCardResponse);

    notifyListeners();
  }

  void updateFlashCard(FlashCard newFlashCard) async {
    String url = backendUrl +
        "/api/flashCard/" +
        newFlashCard.id +
        "?email=" +
        (AuthLogin.email ?? '');
    Uri uri = Uri.parse(url);

    final flashCardJson = await http.put(
      uri,
      body: json.encode(newFlashCard.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    notifyListeners();
  }

  void toggleFlashCardFavorite(String id, bool isFavorite) async {
    String url = backendUrl +
        "/api/flashCard/" +
        id +
        "/favorite/" +
        isFavorite.toString();
    Uri uri = Uri.parse(url);

    http.put(uri);
  }

  Future<String?> searchMeaningOnline(String word) async {
    String url = "https://api.dictionaryapi.dev/api/v2/entries/en/" + word;
    Uri uri = Uri.parse(url);

    var res = await http.get(uri);

    return (jsonDecode(res.body).runtimeType == List<dynamic>)
        ? jsonDecode(res.body)[0]['meanings'][0]["definitions"][0]["definition"]
        : null;
  }
}
