import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/provdier/register_provider.dart';
import 'package:pop/uitls/uid.dart';
import 'package:pop/widgets/custom_button.dart';
import 'package:pop/widgets/custom_text.dart';
import 'package:pop/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  var ref = FirebaseDatabase.instance.ref("Users");

  @override
  Widget build(BuildContext context) {
    var firebaseProvider = Provider.of<FirebaseService>(context);
    var registrationProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText("Sign Up"),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                textEditingController: registrationProvider.nameController,
                hintText: "Name",
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                textEditingController: registrationProvider.emailController,
                hintText: "Email",
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                textEditingController: registrationProvider.passwordController,
                hintText: "Password",
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () {
                      createUser(
                        context: context,
                        email: registrationProvider.emailController.text,
                        password: registrationProvider.passwordController.text,
                        firebaseService: firebaseProvider,
                        registerProvider: registrationProvider,
                        name: registrationProvider.nameController.text,
                      );
                    },
                    text: "Sign Up",
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void createUser(
      {FirebaseService? firebaseService,
      RegisterProvider? registerProvider,
      context,
      name,
      email,
      password}) async {
   
    dynamic result =
        await firebaseService!.createNewUser(name, email, password);
    try {
      uid = result.uid;
      ref.child(uid).set({
        "email": email,
        "password": password,
        "score": 0,
      });
    } catch (e) {
      print(e.toString());
    }
    if (result == null) {
      print("Email or Password is not valid !");
    } else {
      print("Successfully registered");
      registerProvider!.nameController.clear();
      registerProvider.emailController.clear();
      registerProvider.passwordController.clear();
      Navigator.of(context).pop();
    }
  }
}
