import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sihwaterresq/Screens/otp.dart';
import 'package:sihwaterresq/widgets/textbox.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _reenterpassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  late String _verificationId;
  bool _isProcessing = false;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _reenterpassword.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final keyboardsize = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Container(
        color: Colors.blue[100],
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "WATER RESQ",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your City, Your voice, Your Change!",
              style: GoogleFonts.jost(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            textbox("Username", _username),
            textbox("Password", _password),
            textbox("Re-Enter password", _reenterpassword),
            textbox("Phone No.", _phone),
            textbox("Email", _email),
            if (_isProcessing) CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.02, right: screenWidth * 0.02, top: 20),
              child: Container(
                width: double
                    .infinity, // Make the button width match the container
                child: ElevatedButton(
                  onPressed: RegisterNewUser,
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.black)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the border radius here
                      ),
                    ),
                  ),
                  child: Text(
                    "Create a New Account",
                    style: GoogleFonts.jost(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onVerticalDragDown: (_) {
                  // Close the modal bottom sheet when swiping down
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_downward_rounded, size: 50)),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void RegisterNewUser() async {
    String username = _username.text;
    String password = _password.text;
    String checkpassword = _reenterpassword.text;
    String email = _email.text;
    String phone = _phone.text;

    if (username.isEmpty ||
        password.isEmpty ||
        checkpassword.isEmpty ||
        email.isEmpty ||
        phone.isEmpty) {
      showErrorDialog('Fields cannot be empty.');
    } else if (phone.length != 10) {
      showErrorDialog('Phone number should be 10 digits long.');
    } else if (password != checkpassword) {
      showErrorDialog('Passwords do not match.');
    } else if (password.length <= 10) {
      showErrorDialog('Password length is too short try a strong password');
    } else if (!isValidEmail(email)) {
      showErrorDialog('Invalid email.');
    } else {
      setState(() {
        _isProcessing = true;
      });
      bool isAlreadyRegistered = await isUserExists(username, phone);
      print(isAlreadyRegistered);
      if (isAlreadyRegistered) {
        Navigator.pop(context);
        print("asdf");
        showErrorDialog('Username or phone number is already registered.');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otp(
              username: username,
              email: email,
              password: password,
              phone: phone,
            ),
          ),
        );
        // sendotp(phone);
        // Navigator.pop(context);
        // print("asd");
        // otp(phone,email,username,password);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  bool isValidEmail(String email) {
    // Define a regular expression for email validation
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    // Use the RegExp's hasMatch method to check if the email matches the pattern
    return emailRegExp.hasMatch(email);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(message),
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
  }

  ////////////////////////CHecking if user is  already registered////////////////////////////////////////////////
  Future<bool> isUserExists(String username, String phone) async {
    try {
      DatabaseEvent usernameEvent = await _databaseReference
          .child('users')
          .orderByChild('username')
          .equalTo(username)
          .once();
      DataSnapshot usernameSnapshot = usernameEvent.snapshot;
      DatabaseEvent phoneEvent = await _databaseReference
          .child('users')
          .orderByChild('phone')
          .equalTo(phone)
          .once();
      DataSnapshot phoneSnapshot = phoneEvent.snapshot;
      print("qwertyuiop");
      return usernameSnapshot.value != null || phoneSnapshot.value != null;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

//   ///////////////////otp sending////////////////////////
//   void sendotp(String phone) async {
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: '+91' + phone,
//     verificationCompleted: (PhoneAuthCredential credential) {},
//     verificationFailed: (FirebaseAuthException e) {},
//     codeSent: (String verificationId, int? resendToken) {
//       _verificationId = verificationId; // Store the verificationId
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {},
//   );
// }

//   ////////////////////////////////////OTP VERFICATION///////////////////////////////////////////////////////////////////////
//   void otp(String phone,String email,String username,String password) {
//   TextEditingController _otpController = TextEditingController();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Enter OTP'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'OTP'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 String enteredOtp = _otpController.text;
//                 // Create a PhoneAuthCredential with the provided verification ID and OTP
//                 PhoneAuthCredential phoneAuthCredential =
//                     PhoneAuthProvider.credential(
//                         verificationId: _verificationId, smsCode: enteredOtp);
//                 try {
//                   // Sign in the user with the credential
//                   await FirebaseAuth.instance
//                       .signInWithCredential(phoneAuthCredential);
//                   // User successfully signed in. Now, store the user data in the database
//                   final userReference = _databaseReference.child('users/$phone');
//                   await userReference.set(
//                     {
//                       'username': username,
//                       'password': password,
//                       'email': email,
//                       'phone': phone,
//                     },
//                   );
//                   Navigator.pop(context);
//                 } catch (e) {
//                   // If the OTP is incorrect, an error will be thrown
//                   showErrorDialog('Incorrect OTP. Please try again.');
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
}
