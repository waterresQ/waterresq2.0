import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';
import 'package:sihwaterresq/Screens/alerts.dart';
import 'package:sihwaterresq/Screens/feed.dart';
import 'package:sihwaterresq/Screens/home.dart';
import 'package:sihwaterresq/Screens/loading.dart';
import 'package:sihwaterresq/Screens/login.dart';
import 'package:sihwaterresq/Screens/menuicons/emergency.dart';
import 'package:sihwaterresq/Screens/menuicons/precautions.dart';
import 'package:sihwaterresq/Screens/menuicons/report.dart';
import 'package:sihwaterresq/Screens/menuicons/weather.dart';
import 'package:sihwaterresq/Screens/nointernetpage.dart';
import 'package:sihwaterresq/firebase_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotification();
  // runApp(MyApp());
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(nointernetpage());
  } else {
    // WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseApi().initNotification();
    runApp(MyApp());
  }
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
      routes: {
        '/emergency': (context) => emergency(),
        '/report': (context) => const report(),
        '/precautions': (context) => Precautions(),
        '/weather': (context) => const WeatherApp(),
        '/feed': (context) => const feedscreen(),
        '/map': (context) => const usermaps(),
        '/alerts': (context) => const alerts(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: FutureBuilder<String>(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(); // Show loading screen while waiting
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data == 'X' ? const login() : home();
            }
          }
        },
      ),
    );
  }
}
