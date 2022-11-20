import 'dart:io';
import 'package:flashcard/models/AuthLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService with ChangeNotifier {
  String backendUrl = "http://10.0.2.2:3000";

  Future<bool> login(email, password) async {
    String url = backendUrl + "/api/login";
    Uri uri = Uri.parse(url);

    var res = await http.post(
      uri,
      body: json.encode({'email': email, 'password': password}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    String? emailLogin = jsonDecode(res.body) as String?;

    if (emailLogin != null) {
      AuthLogin.email = emailLogin;
      notifyListeners();

      return true;
    }

    return false;
  }

  Future<bool> signup(email, password) async {
    String url = backendUrl + "/api/signup";
    Uri uri = Uri.parse(url);

    var res = await http.post(
      uri,
      body: json.encode({'email': email, 'password': password}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    bool isSuccess = jsonDecode(res.body) as bool;

    return isSuccess;
  }

  void logout() {
    AuthLogin.email = null;

    notifyListeners();
  }

  bool get isLogin {
    return AuthLogin.email != null;
  }

  String? getEmailUserLogined() {
    return AuthLogin.email;
  }
}
