import 'package:flutter/material.dart';

class menupage extends StatefulWidget {
  const menupage({Key? key}) : super(key: key);

  @override
  State<menupage> createState() => _menupageState();
}

class _menupageState extends State<menupage> {
  Color bg = Colors.white;
  Image complaint = Image.asset(
    'lib/widgets/menuimages/complaint.png',
    height: 110,
    width: 100,
  );
  Image alert = Image.asset(
    'lib/widgets/menuimages/alert.png',
    height: 110,
    width: 100,
  );
  Image emergency = Image.asset(
    'lib/widgets/menuimages/emergency.png',
    height: 80,
    width: 80,
  );
  Image report = Image.asset(
    'lib/widgets/menuimages/feeds.png',
    height: 110,
    width: 100,
  );
  Image map = Image.asset(
    'lib/widgets/menuimages/map.png',
    height: 110,
    width: 110,
  );
  Image precaution = Image.asset(
    'lib/widgets/menuimages/precaution.png',
    height: 110,
    width: 100,
  );
  Image weather = Image.asset(
    'lib/widgets/menuimages/weather.png',
    height: 110,
    width: 100,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 35,
            mainAxisSpacing: 30,
            children: [
              itemDashboard('report', report),
              itemDashboard('alert', alert),
              itemDashboard('Raise complaint', complaint),
              itemDashboard('traffic updates', map),
              itemDashboard('weather', weather),
              itemDashboard('Emergency contact', emergency),
              itemDashboard('precautions', precaution),
            ],
          ),
        ),
      ),
    );
  }
}

itemDashboard(String title, Image image) => Container(
      child: GestureDetector(
        onTap: () {
          print("Printed $title");
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 177, 216, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 2,
                spreadRadius: 1,
                color: Color.fromARGB(255, 157, 156, 156),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: image),
              const SizedBox(
                height: 7,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(title.toUpperCase())),
            ],
          ),
        ),
      ),
    );
