import 'package:checkers_game_fff/screens/after_create_lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth_helper/auth_helper_lobbies.dart';
import '../../controller/app_controller.dart';
import '../../models/lobbies_model.dart';
import '../../screens/online_game_screen.dart';

class MyButton extends StatefulWidget {
  final String uid;
  final String buttonContent;
  const MyButton({Key? key , required this.buttonContent , required this.uid}) : super(key: key);


  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  void initState() {
    AppController.to.fillBoard();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left:20),
        child: StreamBuilder<Object>(
          stream: streamFunctionAll(),
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
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ],
              );
            }
            return ElevatedButton(
                onPressed: (){
                  LobbiesModel lobbiesModel = LobbiesModel(
                      create: DateTime.now().toString(),
                      participant: "",
                      founder: widget.uid.toString(),
                      board: convert(AppController.to.taslar!),
                      founderColor: "player.blue",
                      participantColor: "player.white",
                      currentPlayer: widget.uid.toString(),
                      scoreWhite: 0,
                      scoreBlue: 0);
                  if (lobbiesModel.participant == "") {
                    AuthHelperLobbies().addLobbies(lobbiesModel , widget.uid);
                    Get.to(AfterCreateLobby(uid: widget.uid));
                  }else{
                    Get.to(OnlineGameScreen(uid: widget.uid, isCreator: true));
                  }
                },
                child: Text(
                  widget.buttonContent ,style: const TextStyle(
                  fontWeight:FontWeight.w700,fontSize: 17
                ),),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                elevation: 20
              ),
            );
          }
        ),
      ),
    );
  }

  streamFunctionAll() {
    return FirebaseFirestore.instance
        .collection('lobbies')
        .doc(widget.uid)
        .snapshots();
  }

  convert(Map<int, player> datas) {
    Map<String, String> datalar = {};
    datas.forEach((key, value) {
      datalar[key.toString()] = value.toString();
    });
    return datalar;
  }
}
