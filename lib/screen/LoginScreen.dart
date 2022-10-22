import 'package:flutter/material.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/screen/loadingPage.dart';
import 'package:pop/screen/login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FirebaseService>(context);
    return StreamBuilder(
        stream: provider.auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const LoadingPage();
          }
          // return PhoneAuthPage();
          return const LoginPage();
        });
  }
}
