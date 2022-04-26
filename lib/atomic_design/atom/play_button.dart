import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth_helper/auth_helper_lobbies.dart';
import '../../screens/online_game_screen.dart';

class PlayButton extends StatelessWidget {
  final String uid;
  const PlayButton({Key? key , required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: streamFunction(),
        builder: (context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          onPressed: () {
            if (snapshot.data!.docs.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          'Kullanıcı Bulunamadı !'),
                      content: const Text(
                          'Oynamak için yeni oyun oluşturun'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Close')),
                      ],
                    );
                  });
            }else {
              AuthHelperLobbies().updateLobbies(uid);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:
                      const Text('Bağlantı Kuruldu.'),
                      content: const Text(
                          'Oynamak için devam edin.'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Get.to(OnlineGameScreen(
                                uid: uid,
                                isCreator: false,
                              ));
                            },
                            child: const Text('Devam')),
                      ],
                    );

                  });
            }
          },
          child: const Text(
            "Play",
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red),
        );
      }
    );
  }
  streamFunction() {
    return FirebaseFirestore.instance
        .collection('lobbies')
        .where('participant', isEqualTo: "")
        .snapshots();
  }
}
