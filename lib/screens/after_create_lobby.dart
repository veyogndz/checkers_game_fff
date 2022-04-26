import 'package:checkers_game_fff/auth_helper/auth_helper_lobbies.dart';
import 'package:checkers_game_fff/screens/entry_screen.dart';
import 'package:checkers_game_fff/screens/lobbies_screen.dart';
import 'package:checkers_game_fff/screens/online_game_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AfterCreateLobby extends StatefulWidget {
  final String uid;

  const AfterCreateLobby({Key? key, required this.uid}) : super(key: key);

  @override
  State<AfterCreateLobby> createState() => _AfterCreateLobbyState();
}

class _AfterCreateLobbyState extends State<AfterCreateLobby> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("After Create Lobby"),
          leading: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Geri gitmek kurulan oyunu siler.'),
                        content: const Text('Gitmek için devam edin.'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {

                                AuthHelperLobbies().deleteLobbies(widget.uid);
                                Get.to(const EntryScreen(),
                                );
                              },
                              child: const Text('Devam')),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.brown,
        ),
        body: StreamBuilder<Object>(
            stream: streamFunctionAll(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Text("BOŞ");
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.data["participant"].isEmpty) {
                return Stack(
                  children: [
                    Container(
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        color: Colors.red,
                        strokeWidth: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 450, left: 40),
                      child: const Text(
                        "Please Wait, Player Will Come Soon.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                Get.to(OnlineGameScreen(
                  uid: widget.uid,
                  isCreator: true,
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: const EdgeInsets.only(left: 65),
                  margin: const EdgeInsets.all(20),
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.red,
                    strokeWidth: 15,
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }

  streamFunctionAll() {
    return FirebaseFirestore.instance
        .collection('lobbies')
        .doc(widget.uid)
        .snapshots();
  }
}
