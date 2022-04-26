import 'package:checkers_game_fff/screens/entry_screen.dart';
import 'package:checkers_game_fff/screens/lobbies_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  final String uid;

  const SignInScreen({Key? key ,required this.uid}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  late FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIGN-IN SCREEN"),
        leading: const Icon(Icons.assignment_turned_in),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/signin.jpg"), fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(66),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blueGrey,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.circle),
                      labelText: "E-MAIL",
                    ),
                    keyboardType: TextInputType.emailAddress,
                   controller: emailController,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blueGrey,
                  ),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.circle),
                      labelText: "PASSWORD",
                    ),
                   controller: passwordController,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 180,
                  height: 35,
                  child: ElevatedButton(
                      onPressed: () async {
                         loginUser();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("Sign-In")),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void loginUser() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //AuthHelper().audioLogin =_userCredential.user!.uid;
      if (_userCredential.user != null) {
       Get.to(const EntryScreen());
      }
      debugPrint("Giriş Başarılı " + _userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}


