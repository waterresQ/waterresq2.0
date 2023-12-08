import 'package:flutter/material.dart';

class emergency extends StatelessWidget {
  const emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GridView.count(
          crossAxisCount: 1,
          children: [
            Container(
              width: 50,
              height: 30,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.call),
                label: Text("POLICE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
