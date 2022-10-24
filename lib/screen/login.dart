import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/randomGame/FindingScreen.dart';
import 'package:pop/uitls/uid.dart';
import 'package:provider/provider.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/provdier/login_provider.dart';
import 'package:pop/screen/registor_page.dart';
import 'package:pop/widgets/custom_button.dart';
import 'package:pop/widgets/custom_text.dart';
import 'package:pop/widgets/custom_text_button.dart';
import 'package:pop/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var firebaseProvider = Provider.of<FirebaseService>(
      context,
    );
    var loginProvider = Provider.of<LoginProvider>(context);
    // var a = firebaseProvider.;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText("Login"),
                const SizedBox(
                  height: 130,
                ),
                CustomTextField(
                  textEditingController: loginProvider.emailController,
                  hintText: "Email",
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  textEditingController: loginProvider.passwordController,
                  hintText: "Password",
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextButton(
                    text: "Not Registered? Sign Up",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    }),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () {
                        loginUser(
                          firebaseProvider: firebaseProvider,
                          context: context,
                          email: loginProvider.emailController.text,
                          loginProvider: loginProvider,
                          password: loginProvider.passwordController.text,
                        );
                      },
                      text: "Login",
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Back",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser({firebaseProvider, loginProvider, email, password, context}) async {
    var result = await firebaseProvider.loginUser(email, password);
    uid = result.uid;
    if (result == null) {
      Fluttertoast.showToast(msg: "wrong email and password");
    } else {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context) => FindingScreen(),));
    }
  }
}
