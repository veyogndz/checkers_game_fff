import 'package:get_storage/get_storage.dart';

import '../controller/app_controller.dart';

class StorageService {
  final storage = GetStorage();

  //Map<int, Player> taslar = {};

  int getScoreWhite() {
    return storage.read("scoreWhite") ?? 0;
  }

  setScoreWhite(int scoreWhite) {
    storage.write("scoreWhite", scoreWhite);
  }

  int getScoreBlue() {
    return storage.read("scoreBlue") ?? 0;
  }

  setScoreBlue(int scoreBlue) {
    storage.write("scoreBlue", scoreBlue);
  }

  Map<int, player> getTaslar() {
    Map<int, player> fakTaslar = {};
    Map? a = storage.read("taslar");
    a?.forEach(
      (key, value) {
        fakTaslar[int.parse(key)] = convertStringtoPlayer(value);
      },
    );
    return fakTaslar;
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

//enum Player { White, Blue, Empty }
  setTaslar(Map<int, player> value) async {
    Map<String, String> fakeTaslar = {};

    for (int i = 0; i < 81; i++) {
      //print("key: $i , value: ${value[i]}");
      fakeTaslar[i.toString()] = value[i].toString();
    }
    await storage.write("taslar", fakeTaslar);
  }
}
/*
  value.forEach((key, value) {
      try{
        print("key: $key , value: $value");
        fakeTaslar[key] = value.toString();
        print("map: $fakeTaslar");
      }
      catch(e){
        print(e);
      }
    });
*/
