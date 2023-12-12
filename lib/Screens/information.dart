import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class information extends StatefulWidget {
  const information({super.key});

  @override
  State<information> createState() => _informationState();
}

class _informationState extends State<information> {
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
            Container(
              padding:
                  EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 20),
              child: Column(
                children: [
                  const Text(
                    "We're on a mission to make our community stronger in times of need, and we believe you can play a crucial role! 🌐 Whether it's updating news or providing assistance during emergencies, your support can make a significant impact.",
                    maxLines: 7,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "By Clicked the button bellow you can apply to start a community and be a admin for that",
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Apply to start a community"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 2,
                decoration: BoxDecoration(color: Colors.black),
                child: Text(""),
              ),
            ),
            SizedBox(height: 20,),
            const Text(
              "Is the admin team functioning properly?",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 3, 0, 0)),
            ),
            const Text(
              "Feedback about the APP",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 3, 0, 0)),
            ),
            SizedBox(height: 50,),
            const Text(
              "waterresQfeedback@gmail.com",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 3, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
