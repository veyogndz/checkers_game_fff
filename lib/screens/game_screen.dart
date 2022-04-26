import 'package:checkers_game_fff/controller/app_controller.dart';
import 'package:checkers_game_fff/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int oldIndex = -1;

  @override
  void initState() {
    var storageServer = StorageService().getTaslar();
    if (storageServer.isEmpty) {
      AppController.to.fillBoard();
    } else {
      AppController.to.taslar = storageServer;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("THINK TO WIN"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/back.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
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
                      child: GetBuilder<AppController>(
                        builder: (context) {
                          return Text(
                            "SCORE : " + AppController.to.scoreWhite.toString(),
                            style: const TextStyle(
                                fontSize: 46, color: Colors.blue),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 532, left: 60),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    width: 250,
                    height: 60,
                    color: Colors.black,
                    child: GetBuilder<AppController>(
                      builder: (context) {
                        return Text(
                          "SCORE : " + context.scoreBlue.toString(),
                          style: const TextStyle(
                              fontSize: 46, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 142, left: 10, right: 10, bottom: 204),
              child: GetBuilder<AppController>(
                builder: (appController) {
                  return GridView.count(
                    padding: const EdgeInsets.all(5),
                    crossAxisCount: 9,
                    children: List.generate(
                      81,
                      (index) {
                        player? _domino = appController.taslar?[index];
                        return GestureDetector(
                          onTap: () {
                            print(appController.current != _domino);
                            print(_domino != player.empty);
                            print(appController.possibleSquares.contains(index));

                            if (appController.current != _domino) {
                              if (_domino != player.empty) {
                                appController.checkNextSquare(index);
                              } else if (appController.possibleSquares
                                  .contains(index)) {
                                appController.move(index, oldIndex,
                                    appController.taslar?[oldIndex]);
                              }
                              oldIndex = index;
                              AppController.to.taslarUpdate();
                            }
                          },
                          child: Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: _domino == player.blue
                                          ? Colors.blue
                                          : _domino == player.white
                                              ? Colors.white
                                              : Colors.transparent,
                                      shape: BoxShape.circle),
                                ),
                                //pula tıklandığında oluşan fake pullar.
                                Container(
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: appController.possibleSquares
                                              .contains(index)
                                          ? Colors.green.withOpacity(0.7)
                                          : Colors.transparent,
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color:
                                    index % 2 == 0 ? Colors.black : Colors.red),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
