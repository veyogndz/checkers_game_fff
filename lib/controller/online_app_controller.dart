import 'dart:async';
import 'package:checkers_game_fff/controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnlineAppController extends GetxController {
  static OnlineAppController to = Get.find();
  int counterFounder = 0;
  int counterParticipant = 0;
  Timer? timer;
  Timer? tim;
  List<int> squares = [];
  Map<int, player>? stones = {};
  int scoreWhite = 0;
  int scoreBlue = 0;

  startTimerPlayerFounder() {
    counterFounder=30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counterFounder > 0) {
        counterFounder--;
        print("Counter Founder"+counterFounder.toString());
        update();
      } else {
        timer.cancel();
        update();
      }
    });
  }

  startTimerPlayerParticipant() {
    counterParticipant = 30;
    tim = Timer.periodic(const Duration(seconds: 1), (tim) {
      if (counterParticipant > 0) {
        counterParticipant--;
        print("CounterParticipant"+counterParticipant.toString());
        update();
      } else {
        tim.cancel();
        update();
      }
    });
  }

  move(index, oldIndex, user) {
    if (squares.contains(index)) {
      stones![oldIndex] = player.empty;
      stones![index] = user;
      if ((oldIndex + index) / 2 < stones?.length) {
        if (stones![((oldIndex + index) / 2).toInt()] != user &&
            stones![((oldIndex + index) / 2).toInt()] != player.empty) {
          stones![((oldIndex + index) / 2).toInt()] = player.empty;
          //Skor Güncelleme
          if (user == player.white) {
            scoreWhite++;
          } else if (user == player.blue) {
            scoreBlue++;
          }
        }
      }
    }
    update();
    squares.clear();
  }

  convertToPlayer(Map<String, dynamic> datas) {
    Map<int, player> datalar = {};
    datas.forEach((key, value) {
      datalar[int.parse(key)] = convertStringtoPlayer(value);
    });
    return datalar;
  }

  checkNextSquare(index) {
    debugPrint(index.toString());
    squares.clear();
    player? _myColor = stones![index];
    debugPrint("taş rengi : " + _myColor.toString());
    //sağ alt
    if (index + 10 < stones?.length) {
      //boş kareleri bul
      if (stones![index + 10] == player.empty) {
        squares.add(index + 10);
      }
      //rakip üzerinden atlama
      else if (stones![index + 10] != _myColor) {
        if (stones![index + 20] == player.empty) {
          squares.add(index + 20);
        }
      }
    }
    //sol alt
    if (index + 8 < stones?.length) {
      //boş kareleri bul
      if (stones![index + 8] == player.empty) {
        squares.add(index + 8);
      }
      //rakip üzerinden atlama
      else if (stones![index + 8] != _myColor) {
        if (stones![index + 16] == player.empty) {
          squares.add(index + 16);
        }
      }
    }
    //sol üst
    if (index - 10 < stones?.length) {
      //boş kareleri bul
      if (stones![index - 10] == player.empty) {
        squares.add(index - 10);
      }
      //rakip üzerinden atlama
      else if (stones![index - 10] != _myColor) {
        if (stones![index - 20] == player.empty) {
          squares.add(index - 20);
        }
      }
    }
    //sağ üst
    if (index - 8 < stones?.length) {
      if (stones![index - 8] == player.empty) {
        squares.add(index - 8);
      }
      //rakip üzerinden atlama
      else if (stones![index - 8] != _myColor) {
        if (stones![index - 16] == player.empty) {
          squares.add(index - 16);
        }
      }
    }
    debugPrint("squares $squares");
    update();
  }

  convertStringtoPlayer(String tas) {
    switch (tas) {
      case "player.white":
        return player.white;
      case "player.blue":
        return player.blue;
      case "player.empty":
        return player.empty;
    }
  }

  convert(Map<int, player> datas) {
    Map<String, String> datalar = {};
    datas.forEach((key, value) {
      datalar[key.toString()] = value.toString();
    });
    return datalar;
  }
}
