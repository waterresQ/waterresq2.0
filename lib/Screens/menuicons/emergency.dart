import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class emergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 177, 216, 255),
        appBar: AppBar(
          title: const Text(
            "Emergency Reach",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: ListView(
            children: [
              const Text(
                "NOTE:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "These contact numbers remain accessible even when there is no signal",
                style: TextStyle(fontSize: 23),
              ),
              ContactWidget('Police', '100'),
              ContactWidget('Ambulance', '108'),
              ContactWidget('National Disaster Response Force', '1070'),
              ContactWidget('Fire Station', '101'),
              ContactWidget('Common Emergency', '112'),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  final String name;
  final String number;

  ContactWidget(this.name, this.number);

  @override
  Widget build(BuildContext context) {
    Uri phoneNumber = Uri(scheme: 'tel', path: number);

    return _buildContactButton(name, phoneNumber);
  }

  Widget _buildContactButton(String name, Uri phoneNumber) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        onPressed: () {
          _launchPhoneCall(phoneNumber);
        },
        icon: const Icon(
          Icons.call,
          size: 30,
          color: Colors.black,
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                name,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchPhoneCall(Uri number) async {
    await launchUrl(number);
  }
}
