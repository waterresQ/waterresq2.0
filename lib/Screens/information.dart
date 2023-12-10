import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class information extends StatefulWidget {
  const information({super.key});

  @override
  State<information> createState() => _informationState();
}

class _informationState extends State<information> {
  final TextEditingController _password = TextEditingController();
  int requestforcommunity = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Information"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: Column(
          children: [
            requestforcommunity == 0 ? Container() : buildTextFormField(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if(requestforcommunity==1){requestforcommunity = 0;}
                  else{requestforcommunity = 1;}
                });
              },
              child: requestforcommunity == 0
                  ? Text("Request for Community")
                  : Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField() {
    return TextFormField(
      controller: _password,
      style: GoogleFonts.jost(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        hintStyle: GoogleFonts.jost(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      obscureText: true,
    );
  }
}
