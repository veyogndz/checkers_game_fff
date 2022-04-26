import 'package:checkers_game_fff/atomic_design/atom/create_button.dart';
import 'package:checkers_game_fff/atomic_design/atom/name_box.dart';
import 'package:checkers_game_fff/atomic_design/atom/play_button.dart';
import 'package:checkers_game_fff/atomic_design/atom/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LobbiesScreen extends StatelessWidget {
  final String uid;

  LobbiesScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.gamepad_outlined),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.brown,
          image: DecorationImage(
              image: AssetImage("assets/backOriginal.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              width: 384,
              height: 80,
              color: Colors.amber.shade200,
              child: Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: Row(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://cs2.gamemodding.com/images/750x407/055157e8b66d59e13ee5fb0243fe84bc80e0be7af5cd52642508b3483ed3d8e5.jpg"),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot> (
                      stream: streamFunctionAll(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        print("asdasdasd "+snapshot.data!["userName"].toString());
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        return
                          Container(
                            padding: const EdgeInsets.all(0.1),
                            child:NameBox(name: snapshot.data!["userName"]),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, left: 4, right: 4, bottom: 20),
              child: Container(
                width: 400,
                height: 480,
                color: Colors.blueGrey,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.red,
                            ),
                            Visibility(
                              visible: snapshot.hasData,
                              child: Text(
                                snapshot.data.toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      return Container(
                        padding: const EdgeInsets.all(15),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 3,
                                    crossAxisSpacing: 25,
                                    mainAxisSpacing: 20),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext ctx, index) {
                              DocumentSnapshot data = snapshot.data!.docs[index];
                              return Container(
                                padding: const EdgeInsets.all(6),
                                width: 120,
                                height: 120,
                                color: Colors.amber.shade200,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "https://i.imgur.com/BoN9kdC.png"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.5),
                                      child: MyText(id: data['founderColor']),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      height: 40,
                                      child: PlayButton(uid: uid),
                                    )
                                  ],
                                ),
                              );
                            }),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  MyButton(buttonContent: "Create Room", uid: uid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('lobbies').snapshots();

  streamFunctionAll() {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }
}
