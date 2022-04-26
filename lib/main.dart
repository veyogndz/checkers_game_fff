import 'package:checkers_game_fff/firebase_options.dart';
import 'package:checkers_game_fff/screens/entry_screen.dart';
import 'package:checkers_game_fff/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controller/app_controller.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppController appController = Get.put(AppController());

  late User? user;
  void checkLog()async{
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  void initState() {
    checkLog();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
            ),
            debugShowCheckedModeBanner: false,
            home: user != null ? const EntryScreen() :  const SignUpScreen(),

          );

  }
}
