import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController(text: "a@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "123456");
  handleLogin() {
    print("handleLoign");
    notifyListeners();
  }
}
