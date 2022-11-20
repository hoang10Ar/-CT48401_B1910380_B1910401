import 'dart:math' as math;
import 'package:flashcard/screens/FlashCardsScreen.dart';
import 'package:flashcard/screens/SignupScreen.dart';
import 'package:flashcard/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String message = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Transform.rotate(
              angle: -math.pi / 4,
              child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/4560/4560899.png",
                  height: 150,
                  width: 150),
            ),
            const SizedBox(height: 30),
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: ListView(
                    children: [
                      buildEmailField(),
                      buildPasswordField(),
                      const SizedBox(height: 10),
                      Text(message, style: const TextStyle(fontSize: 16)),
                      message == ""
                          ? const SizedBox(height: 0)
                          : const SizedBox(height: 10),
                      buildButtonLogin(),
                      message == ""
                          ? const SizedBox(height: 0)
                          : const SizedBox(height: 10),
                      buildButtonSignup(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(labelText: "Email"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(labelText: "Password"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextButton buildButtonLogin() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          bool isLoginSuccess = await context
              .read<AuthService>()
              .login(emailController.text, passwordController.text);
          if (isLoginSuccess) {
            Navigator.of(context).popAndPushNamed(FlashCardsScreen.routeName);
          } else {
            setState(() {
              message = 'Login failed!';
            });
          }
        } else {
          setState(() {
            message = '';
          });
        }
      },
    );
  }

  TextButton buildButtonSignup() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).popAndPushNamed(SignupScreen.routeName);
      },
      child: const Text("Signup", style: TextStyle(fontSize: 20)),
    );
  }
}
