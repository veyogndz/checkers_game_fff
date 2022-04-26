import 'package:checkers_game_fff/models/lobbies_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthHelperLobbies {
  CollectionReference lobbiesReference = FirebaseFirestore.instance.collection("lobbies");

  Future addLobbies(LobbiesModel lobbiesModel, String uid) async {
    try {
      await lobbiesReference.doc(uid).set(lobbiesModel.toJson());
    } catch (a) {
      debugPrint(a.toString());
    }
  }

  Future<void> updateLobbies(String uid) async {
    try {
    await lobbiesReference.get().then((value) async{
        if (value.docs.isNotEmpty) {
          await lobbiesReference
              .doc(value.docs.first.id)
              .update({'participant':uid })
              .then((value) => debugPrint("Participant Updated"))
              .catchError((error) => debugPrint("Failed to update nameasda: $error"));
          SetOptions(merge: true);
        }
      });
    } catch (a) {
      debugPrint("ERROR $a");
    }
  }
  Future<void> updateBoard(String uid , Map<String,String> backStones ,  )async{
    await lobbiesReference
        .doc(uid)
        .update({'board': backStones})
        .then((value) => debugPrint("Board Updated"))
        .catchError((error) => debugPrint("Failed to update name: $error"));
      SetOptions(merge: true);
  }
  Future<void> updateCurrent(String uid ,String randomId , String red  )async{
    await lobbiesReference
        .doc(uid)
        .update({'currentPlayer': randomId , 'currentColor' : red})
        .then((value) => debugPrint("Board Updated"))
        .catchError((error) => debugPrint("Failed to update name: $error"));
    SetOptions(merge: true);
  }
  Future<void> updateScores(String uid , int scoreBlue,int scoreWhite  )async{
    await lobbiesReference
        .doc(uid)
        .update({'scoreBlue': scoreBlue , 'scoreWhite' : scoreWhite})
        .then((value) => debugPrint("Board Updated"))
        .catchError((error) => debugPrint("Failed to update name: $error"));
    SetOptions(merge: true);
  }


  Future<void> deleteLobbies(String uid) {
    return lobbiesReference
        .doc(uid)
        .delete()
        .then((value) => print("Lobby Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
