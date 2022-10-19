import 'package:flutter/material.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/screen/loadingPage.dart';
import 'package:pop/screen/login.dart';
import 'package:provider/provider.dart';

class PlayOnline extends StatefulWidget {
  const PlayOnline({super.key});

  @override
  State<PlayOnline> createState() => _PlayOnlineState();
}

class _PlayOnlineState extends State<PlayOnline> {
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
