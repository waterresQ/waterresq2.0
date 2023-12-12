import 'package:flutter/material.dart';

class communitychat extends StatefulWidget {
  communitychat(
      {required this.Communityname,
      required this.username,
      required this.Communityusername,
      required this.phone,
      super.key});
  String Communityname;
  String username;
  String Communityusername;
  String phone;
  @override
  State<communitychat> createState() => _communitychatState();
}

class _communitychatState extends State<communitychat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 231, 255, 237),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Text(widget.Communityname),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 50, // Adjust as needed
                width: MediaQuery.of(context).size.width, // Takes full width
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Admin: ${widget.Communityusername}    Phone NO: ${widget.phone}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                width: MediaQuery.of(context).size.width, // Takes full width
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    // Changed from Column to Row
                    mainAxisSize: MainAxisSize.min, // Set to min
                    children: [
                      const Flexible(
                        child: TextField(
                          maxLines: null, // Set to null
                          style: TextStyle(
                              color:
                                  Colors.white), // Change text color to white
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your message',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)), // Change hint text color to grey
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle the send button press
                        },
                        icon: Icon(Icons.send,
                            color: Colors.white), // Use send icon
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
