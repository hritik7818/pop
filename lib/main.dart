import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pop/provdier/login_provider.dart';
import 'package:pop/provdier/register_provider.dart';
import 'package:pop/provdier/test_provider.dart';
import 'package:pop/screen/home_page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'firebase_options.dart';
import 'firebase_services/authentication_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<FirebaseService>(
      create: (_) => FirebaseService(),
    ),
    ChangeNotifierProvider<RegisterProvider>(
      create: (_) => RegisterProvider(),
    ),
    ChangeNotifierProvider<LoginProvider>(
      create: (_) => LoginProvider(),
    ),
    // ChangeNotifierProvider<DatabaseServices>(
    //   create: (_) => DatabaseServices(),
    // ),
    ChangeNotifierProvider<RealDBProvider>(
      create: (_) => RealDBProvider(),
    ),
  ];
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.russoOneTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
      designSize: const Size(414, 896),
    );
  }
}
