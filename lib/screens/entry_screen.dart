import 'package:checkers_game_fff/screens/lobbies_screen.dart';
import 'package:checkers_game_fff/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/app_controller.dart';
import 'game_screen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late User? user;

  void checkLog() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    checkLog();
    super.initState();
  }
  bool loggedIn=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown, Colors.grey, Colors.brown],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(43),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                gradient: const LinearGradient(
                    colors: [Colors.brown, Colors.grey, Colors.brown]),
                border: Border.all(
                    color: Colors.black87,
                    width: 2.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(200.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("CHECKERS GAME",
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => {
                      Get.to(() => const GameScreen(),
                        transition: Transition.cupertino),
                      AppController.to.taslar?.clear(),
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "2 PLAYERS",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(LobbiesScreen(uid: user!.uid));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "PLAY ONLINE",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar("Veysel", "Mesaj oluşturuldu.",
                          colorText: Colors.white);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "SETTINGS",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
