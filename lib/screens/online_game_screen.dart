import 'package:checkers_game_fff/atomic_design/molecule/remaining_time.dart';
import 'package:checkers_game_fff/auth_helper/auth_helper_lobbies.dart';
import 'package:checkers_game_fff/controller/app_controller.dart';
import 'package:checkers_game_fff/controller/online_app_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineGameScreen extends StatefulWidget {
  final String? uid;
  final bool isCreator;

  const OnlineGameScreen({Key? key, required this.uid, required this.isCreator})
      : super(key: key);

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  final OnlineAppController onlineAppController = Get.put(OnlineAppController());
  int oldIndex = -1;
  Map<String, String>? backStones;
  player selectedColor = player.white;
  String difColor = "";
  Map<String, dynamic> _domino = {};
  String participantId = "";
  String founderId = "";
  String currentPlayer = "";
  String founderColor = "";
  String participantColor = "";
  int? scoreWhite;
  int? scoreBlue;
  bool forFounder = false;
  bool forParticipant = false;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('lobbies').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHECKERS ONLINE GAME"),
        backgroundColor: Colors.brown,
        leading: const Icon(Icons.widgets_outlined),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/ahsapback.jpg"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                DocumentSnapshot data = snapshot.data!.docs.first;
                return Container(
                  padding: const EdgeInsets.all(66),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: 22,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          width: 250,
                          height: 60,
                          color: Colors.black,
                          child: Text(
                            "SCORE : " + data["scoreBlue"].toString(),
                            style: const TextStyle(
                                fontSize: 46, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  DocumentSnapshot data = snapshot.data!.docs.first;
                  return Container(
                    padding: const EdgeInsets.only(top: 532, left: 60),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          width: 250,
                          height: 60,
                          color: Colors.black,
                          child: Text("SCORE :" + data["scoreWhite"].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 46)),
                        ),
                      ],
                    ),
                  );
                }),
            Container(
              margin: const EdgeInsets.only(
                  top: 142, left: 10, right: 10, bottom: 204),
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return GetBuilder<OnlineAppController>(
                    builder: (onlineController) {
                      return GridView.builder(
                          padding: const EdgeInsets.all(21),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 550,
                                  childAspectRatio: 3 / 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: 1,
                          itemBuilder: (BuildContext ctx, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            _domino = data['board'];
                            participantId = data['participant'];
                            founderId = data['founder'];
                            founderColor = data['founderColor'];
                            currentPlayer = data['currentPlayer'];
                            onlineAppController.scoreWhite = data['scoreWhite'];
                            onlineAppController.scoreBlue = data['scoreBlue'];
                            participantColor = data['participantColor'];
                            scoreWhite = data['scoreWhite'];
                            scoreBlue = data['scoreBlue'];

                            return GridView.count(
                              crossAxisCount: 9,
                              children: List.generate(
                                81,
                                (index) {
                                  onlineController.stones =
                                      onlineController.convertToPlayer(_domino);
                                  player fakeDom = onlineController
                                      .convertToPlayer(_domino)[index];

                                 /* if (forFounder == false && currentPlayer==founderId) {
                                      onlineController.startTimerPlayerFounder();
                                      forFounder = true;
                                  }
                                  if (forParticipant == false && currentPlayer == participantId) {
                                      onlineController.startTimerPlayerParticipant();
                                      forParticipant = true;
                                  }*/
                                  return GestureDetector(
                                    onTap: () {
                                      //Founder için if bloğu
                                      if (currentPlayer == founderId &&
                                          widget.isCreator) {
                                        if (fakeDom != player.empty &&
                                            fakeDom ==
                                                (founderColor == "player.blue"
                                                    ? player.blue
                                                    : player.white)) {
                                          onlineController
                                              .checkNextSquare(index);
                                        }
                                        fireStoreUpdateProcess(index);
                                        if (scoreBlue == 9) {
                                          Get.defaultDialog(
                                              title: "You Win",
                                              backgroundColor: Colors.green,
                                              titleStyle: const TextStyle(
                                                  color: Colors.white),
                                              middleTextStyle: const TextStyle(
                                                  color: Colors.white),
                                              textConfirm: "Confirm",
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.red,
                                              content:
                                                  const Text("Kazandınız!"));
                                        }
                                        oldIndex = index;
                                      }
                                      //Participant için if bloğu
                                      if (currentPlayer == participantId &&
                                          !widget.isCreator) {
                                        if (fakeDom != player.empty &&
                                            fakeDom ==
                                                (participantColor ==
                                                        "player.blue"
                                                    ? player.blue
                                                    : player.white)) {
                                          onlineController
                                              .checkNextSquare(index);
                                        }
                                        fireStoreUpdateProcess(index);
                                        if (scoreWhite == 9) {
                                          Get.defaultDialog(
                                              title: "You Win",
                                              backgroundColor: Colors.grey,
                                              titleStyle: const TextStyle(
                                                  color: Colors.white),
                                              middleTextStyle: const TextStyle(
                                                  color: Colors.white),
                                              textConfirm: "Confirm",
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.red,
                                              content:
                                                  const Text("Kazandınız!"));
                                        }
                                        oldIndex = index;
                                      }
                                    },
                                    child: Container(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          //firestore dan gelen taş verilerinin yerlerine göre renkleri
                                          Container(
                                            width: 40,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: fakeDom == player.blue
                                                    ? Colors.blue
                                                    : fakeDom == player.white
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                shape: BoxShape.circle),
                                          ),
                                          //pula tıklandığında oluşan fake pullar.
                                          Container(
                                            width: 40,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: onlineController.squares
                                                        .contains(index)
                                                    ? Colors.green
                                                        .withOpacity(0.7)
                                                    : Colors.transparent,
                                                shape: BoxShape.circle),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: index % 2 == 0
                                              ? Colors.black
                                              : Colors.red),
                                    ),
                                  );
                                },
                              ),
                            );
                          });
                    },
                  );
                },
              ),
            ),
          /*  GetBuilder<OnlineAppController>(builder: (controller) {
              return Column(
                children: [
                  RemainingTime(counter: controller.counterFounder.toString()),
                  Container(
                      padding: const EdgeInsets.only(top: 605),
                      child: RemainingTime(
                          counter: OnlineAppController.to.counterParticipant
                              .toString())),
                ],
              );
            }),*/
          ],
        ),
      ),
    );
  }

  fireStoreUpdateProcess(index) {
    if (OnlineAppController.to.squares.contains(index)) {
      OnlineAppController.to
          .move(index, oldIndex, OnlineAppController.to.stones![oldIndex]);
      backStones =
          OnlineAppController.to.convert(OnlineAppController.to.stones!);
      difColor = founderColor == "player.blue" ? "player.white" : "player.blue";
      if (currentPlayer == participantId) {
        AuthHelperLobbies().updateCurrent(founderId, founderId, difColor);
        AuthHelperLobbies().updateBoard(founderId, backStones!);
        AuthHelperLobbies().updateScores(
            founderId,
            OnlineAppController.to.scoreBlue,
            OnlineAppController.to.scoreWhite);
        OnlineAppController.to.tim!.cancel();
        OnlineAppController.to.timer!.cancel();
        forParticipant = false;
        forFounder = false;
      } else if (currentPlayer == founderId) {
        AuthHelperLobbies().updateCurrent(founderId, participantId, difColor);
        AuthHelperLobbies().updateBoard(founderId, backStones!);
        AuthHelperLobbies().updateScores(
            founderId,
            OnlineAppController.to.scoreBlue,
            OnlineAppController.to.scoreWhite);
        OnlineAppController.to.timer!.cancel();
        OnlineAppController.to.tim!.cancel();
        forFounder = false;
        forParticipant = false;
      }
    }
  }
}
