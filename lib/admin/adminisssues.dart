import 'package:flutter/material.dart';
import 'package:sihwaterresq/admin/screens/adminmap.dart';

class adminissues extends StatefulWidget {
  const adminissues({super.key});

  @override
  State<adminissues> createState() => _adminissuesState();
}

class _adminissuesState extends State<adminissues> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                buildCard(
                  imagePath: 'assets/flood.png',
                  title: 'Water Stagnated & Flooded Areas',
                  description: 'These areas are flooded!',
                ),
                buildCard(
                  imagePath: 'assets/drainage.png',
                  title: 'Drainage Leakage Detected',
                  description: 'Drainage leaks are impacting these locations!',
                ),
                buildCard(
                  imagePath: 'assets/infra.png',
                  title: 'Infrastructure Damages',
                  description:
                      'Identified infrastructure damages in these areas!',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => adminmaps(
                      cat: title,
                    )),
          );
        },
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 155,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: const Color.fromARGB(119, 0, 0, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Flexible(
                            child: Text(
                              description,
                              style: TextStyle(color: Colors.white),
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
