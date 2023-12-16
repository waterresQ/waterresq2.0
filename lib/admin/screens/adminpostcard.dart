import 'package:flutter/material.dart';

class adminpostcard extends StatefulWidget {
  adminpostcard(
      {super.key,
      required this.address,
      required this.date,
      required this.latitude,
      required this.longitude,
      required this.prediction,
      required this.repostcount,
      required this.time,
      required this.username,
      required this.imageurl,
      required this.description});
  String username;
  String date;
  String time;
  String description;
  String repostcount;
  String latitude;
  String longitude;
  String address;
  String prediction;
  String imageurl;
  @override
  State<adminpostcard> createState() => _adminpostcardState();
}

class _adminpostcardState extends State<adminpostcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 221, 235, 249),
          borderRadius: BorderRadius.circular(10), // border radius
          boxShadow: [
            BoxShadow(
              color:
                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // shadow color
              spreadRadius: 5, // shadow spread radius
              blurRadius: 7, // shadow blur radius
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // border radius
                child: Container(
                  height: 150,
                  width:
                      double.infinity, // Set the height to the value you want
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/Rhombus.gif',
                    image: widget.imageurl,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Text(widget.address),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text("Date: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.date),
              const SizedBox(
                width: 110,
              ),
              const Text("Time: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.time),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Latitude & Longitude: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Text(widget.latitude),
              Text(" , "),
              Text(widget.longitude),
            ],
          ),
          Text(widget.username),
          Text(widget.prediction),
          Text(widget.description),
        ]),
      ),
    );
  }
}
