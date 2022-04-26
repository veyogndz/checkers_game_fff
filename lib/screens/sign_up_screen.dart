import 'package:checkers_game_fff/auth_helper/auth_helper_user.dart';
import 'package:checkers_game_fff/models/user_model.dart';
import 'package:checkers_game_fff/screens/entry_screen.dart';
import 'package:checkers_game_fff/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String uid = "";
  bool signUp = false;
  late FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: const Text("SIGN - UP SCREEN"),
        leading: const Icon(Icons.person_add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/signuo.jpg"), fit: BoxFit.cover),
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.circle),
                      labelText: "USER-NAME",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: userNameController,
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
                        signupUserEmailAndPassword();
                        Get.snackbar("Kayıt Başarılı",
                            "Kullanıcı adınız ${userNameController.text}");
                        Get.to(SignInScreen(uid: uid));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("KAYIT")),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signupUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      signUp = true;
      uid = _userCredential.user!.uid;
      print(uid.toString());
      var _myUser = _userCredential.user;

      UserModel userModel = UserModel(
        email: emailController.text,
        password: passwordController.text,
        createDate: DateTime.now().toString(),
        userName: userNameController.text,
      );
      await AuthHelperUser().addUser(userModel, uid);

      if (_myUser!.emailVerified) {
        await _myUser.sendEmailVerification();
      } else {
        debugPrint('kullanıcın maili onaylanmış, ilgili sayfaya gidebilir.');
      }
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
