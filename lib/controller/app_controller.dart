import 'package:get/get.dart';
import '../services/storage_services.dart';

enum player { white, blue, empty }

class AppController extends GetxController {
  static AppController to = Get.find();

   player current = player.white;

  List<int> possibleSquares = [];

  Map<int, player>? taslar ={};

  fillBoard() {
    for (int i = 0; i < 81; i++) {
      if (i < 18 && i % 2 == 0) {
        taslar?[i] = player.blue;
      } else if (i > 63 && i % 2 == 0) {
        taslar?[i] = player.white;
      } else {
        taslar?[i] = player.empty;
      }
    }
  }
  move(index, oldIndex, user) {
    print("user " + user.toString());
    print("oldIndex "+oldIndex.toString());
    print("index "+index.toString());

    if (possibleSquares.contains(index)) {
      taslar?[oldIndex] = player.empty;
      taslar?[index] = user;

      if ((oldIndex + index) / 2 < taslar?.length) {
        if (taslar?[((oldIndex + index) / 2).toInt()] != user && taslar?[((oldIndex + index) / 2).toInt()] != player.empty) {
          taslar?[((oldIndex + index) / 2).toInt()] = player.empty;
          //Skor Güncelleme
          if (user == player.white) {
            scoreBlueUpdate();
          } else if (user == player.blue) {
            scoreWhiteUpdate();
          }
        }
      }
    }
    current = user != player.white ? player.blue : player.white;
    update();
    possibleSquares.clear();
  }

  checkNextSquare(index) {
    print(index);
    possibleSquares.clear();
    player? _myColor = taslar![index];
    print("taş rengi : " + _myColor.toString());

    //sağ alt
    if(index+10<taslar?.length){
      //boş kareleri bul
      if(taslar![index+10] == player.empty){
        possibleSquares.add(index+10);
      }
      //rakip üzerinden atlama
      else if(taslar![index+10] != _myColor){
        if(taslar![index+20] == player.empty){
          possibleSquares.add(index+20);
        }
      }
    }
    //sol alt
    if(index+8<taslar!.length){
      //boş kareleri bul
      if(taslar![index+8] == player.empty){
        possibleSquares.add(index + 8);
      }
      //rakip üzerinden atlama
      else if(taslar![index+8] != _myColor){
        if(taslar![index+16] == player.empty){
          possibleSquares.add(index+16);
        }
      }
    }
    //sol üst
    if(index-10<taslar?.length){
      //boş kareleri bul
      if(taslar![index-10] == player.empty){
        possibleSquares.add(index-10);
      }
      //rakip üzerinden atlama
      else if(taslar![index-10] !=_myColor){
        if(taslar![index-20] == player.empty){
          possibleSquares.add(index-20);
        }
      }
    }
    //sağ üst
    if(index-8 < taslar?.length){
      if (taslar?[index - 8] == player.empty) {
        possibleSquares.add(index - 8);
      }
      //rakip üzerinden atlama
      else if(taslar![index-8] != _myColor){
        if(taslar![index-16] == player.empty){
          possibleSquares.add(index-16);
        }
      }
    }
    print(possibleSquares);
    update();
  }

  @override
  void onInit() {
    scoreWhite = StorageService().getScoreWhite();
    scoreBlue = StorageService().getScoreBlue();
    super.onInit();
  }
  //Map<int, Player> taslar = {};
  int a = 0;
  int scoreWhite = 0;
  int scoreBlue = 0;

  taslarUpdate(){
    StorageService().setTaslar(taslar!);
  }

  //beyaz tasların skoru
  scoreWhiteUpdate() {
    scoreWhite++;
    StorageService().setScoreWhite(scoreWhite);
    update();
  }
  //mavi taşların skoru
  scoreBlueUpdate() {
    scoreBlue++;
    StorageService().setScoreBlue(scoreBlue);
    update();
  }
}
