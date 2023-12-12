import 'package:flutter/material.dart';

class feedcard extends StatefulWidget {
  feedcard(
      {super.key,
      required this.address,
      required this.date,
      required this.description,
      required this.imageurl,
      required this.time,
      required this.usernamepost});
  String imageurl;
  String description;
  String date;
  String time;
  String address;
  String usernamepost;
  @override
  State<feedcard> createState() => _feedcardState();
}

class _feedcardState extends State<feedcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // shadow color
              spreadRadius: 5, // shadow spread radius
              blurRadius: 7, // shadow blur radius
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.usernamepost),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // border radius
                child: Image.network(
                  widget.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: [
                  Text('Date: ${widget.date}'),
                  Spacer(), // date
                  Text('Time: ${widget.time}'), // time
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                maxLines: 3,
              ),
            ), // description
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.address,
                maxLines: 2,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
