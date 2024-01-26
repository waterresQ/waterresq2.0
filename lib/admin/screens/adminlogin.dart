import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sihwaterresq/admin/screens/adminhome.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class adminlogin extends StatefulWidget {
  const adminlogin({super.key});

  @override
  State<adminlogin> createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();
  bool _isProcessing = false;
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            child: Stack(
              children: [
                Container(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.7), // Adjust the opacity va  lue as needed
                      BlendMode.dstATop,
                    ),
                    child: Image.network(
                      "https://wp.culligan.com/wp-content/uploads/2019/08/how-natural-disasters-affect-the-water-system.jpg",
                      width: screenWidth,
                      height: screenHeight / 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [
                        Colors.lightBlue[100]!.withOpacity(0.0),
                        Colors.lightBlue[300]!.withOpacity(0.5)
                      ],
                      [
                        Colors.blue[200]!.withOpacity(0.5),
                        Colors.blue[500]!.withOpacity(1.0)
                      ],
                      [
                        Colors.white.withOpacity(0.5),
                        const Color.fromARGB(255, 121, 190, 246)!
                            .withOpacity(1.0)
                      ],
                      [
                        Colors.lightBlue[400]!.withOpacity(0.5),
                        Colors.lightBlue[800]!.withOpacity(1.0)
                      ],
                    ],
                    durations: [3500, 19440, 10800, 6000],
                    heightPercentages: [0.20, 0.23, 0.25, 0.30],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                  ),
                  waveAmplitude: 15,
                  //backgroundColor: Colors.blue[100],
                  size: const Size(double.infinity, double.infinity),
                  wavePhase: 10,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.35),
                    child: Container(
                      width: screenWidth * 0.85,
                      height: screenHeight * 0.3, // Adjust the width as needed
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: _username,
                              style: GoogleFonts.jost(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                hintStyle:
                                    GoogleFonts.jost(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Color of border when not focused
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Color of border when focused
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _password,
                              style: GoogleFonts.jost(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                hintStyle:
                                    GoogleFonts.jost(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Color of border when not focused
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Color of border when focused
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set the border radius here
                                ),
                              ),
                              obscureText: true,
                            ),
                            if (_isProcessing) CircularProgressIndicator(),
                            ElevatedButton(
                              onPressed: loginclicked,
                              style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: Colors.black)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set the border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.jost(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 100), // Adjust this value as needed
                    child: Text(
                      "WATER RESQ",
                      style: GoogleFonts.jost(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Text(
                      "Your City, Your voice, Your Change!",
                      style: GoogleFonts.jost(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginclicked() async {
    String username = _username.text;
    String password = _password.text;
    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text('Username and password cannot be empty.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isProcessing = true;
      });
      // Check if the username and password match in your database
      bool isMatched = await authenticateUser(username, password);

      if (isMatched) {
        print('Username: $username');
        print('Password: $password');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => adminhome(adminusername: username,),
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      } else {
        // Show an error message if the username and password don't match
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Failed'),
              content: const Text('Invalid username or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isProcessing = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<bool> authenticateUser(String username, String password) async {
    try {
      DatabaseEvent userEvent = await _databaseReference
          .child('admin')
          .orderByChild('username')
          .equalTo(username)
          .once();
      DataSnapshot userSnapshot = userEvent.snapshot;

      if (userSnapshot.value != null) {
        // User with the provided username exists
        // Check if the password matches
        Map<dynamic, dynamic> userData =
            userSnapshot.value as Map<dynamic, dynamic>;
        String storedPassword = userData.values.first['password'];

        return storedPassword == password;
      } else {
        // User with the provided username does not exist
        return false;
      }
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}
