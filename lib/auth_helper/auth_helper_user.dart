import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthHelperUser{
  CollectionReference userReference =
  FirebaseFirestore.instance.collection("users");

  Future addUser(UserModel userModel , String uid) async {
    print("Add User"+uid);
    //DocumentReference documentReference = userReference.doc(audioLogin);
    await userReference.doc(uid).set(userModel.toJson());
  }
}
