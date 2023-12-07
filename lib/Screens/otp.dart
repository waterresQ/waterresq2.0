import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:sihwaterresq/Screens/home.dart';
import 'package:sihwaterresq/Screens/login.dart';
import 'package:sihwaterresq/widgets/textbox.dart';

class otp extends StatefulWidget {
  otp(
      {required this.username,
      required this.email,
      required this.password,
      required this.phone,
      super.key});
  String phone;
  String email;
  String username;
  String password;

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final TextEditingController _otp = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String showmsg = "Press Send OTP to get a otp to your phone number: ";
  final RxString verificationId = ''.obs;
  late FirebaseAuth _auth;
  bool _isLoading = false;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  void dispose() {
    _otp.dispose();
    super.dispose();
  }///////////////////////////////#################################### verifying the user and update the database #####################
  Future<void> verifyAndNavigateToFeedPage() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final otp = _otp.text.trim();
    if (otp.isNotEmpty) {
      bool isVerified = await verifyOTP(otp);
      if (isVerified) {
        try {
          final userReference = _databaseReference.child('users/${widget.phone}');
          await userReference.set(
            {
              'username': widget.username,
              'password': widget.password,
              'email': widget.email,
              'phone': widget.phone,
            },
        );
          print('User details saved to the database');
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => login(),
          ),
        );
        } catch (e) {
          print('Error saving user details to the database: $e');
        }
      } else {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid OTP'),
              content: Text('Please enter a valid OTP.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Please enter the OTP.');
    }

    setState(() {
      _isLoading = false; // Set loading state back to false
    });
  }

///////////////########################################################### phone auth ##########################################################
  Future<void> phoneAuthentication() async {
    setState(() {
      showmsg = "The OTP as been sent Please wait..";
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91${widget.phone}",
      verificationCompleted: (AuthCredential credentials) {},
      codeSent: (verificationId, int? resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        } else {
          print("Something went wrong. Try again.");
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    try{
      var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: otp,
        ),
      );

      return credentials.user != null;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }

//################################################################ main function ###########################################################
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify OTP',
          style: GoogleFonts.jost(
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  showmsg,
                  style: GoogleFonts.jost(
                    fontSize: 18,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                  child: textbox("Enter OTP", _otp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.2,
                  right: screenWidth * 0.2,
                ),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await phoneAuthentication(); // Call phoneAuthentication method
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.black),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Send OTP",
                      style: GoogleFonts.jost(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.2,
                  right: screenWidth * 0.2,
                ),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: verifyAndNavigateToFeedPage,
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.black),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Verify OTP",
                      style: GoogleFonts.jost(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              if(_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Container(
                      width: 100, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                      decoration: BoxDecoration(
                        color: Colors.white, // Set the background color
                        borderRadius:
                            BorderRadius.circular(10), // Add rounded corners
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth:
                              6.0, // Increase the strokeWidth for a thicker circle
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue, // Change to your desired color
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
