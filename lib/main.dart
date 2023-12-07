import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihwaterresq/Screens/home.dart';
import 'package:sihwaterresq/Screens/loading.dart';
import 'package:sihwaterresq/Screens/login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Future<String> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedinuser') ?? 'X';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      home: FutureBuilder<String>(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen(); // Show loading screen while waiting
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data == 'X' ? login() : home();
            }
          }
        },
      ),
    );
  }
}
