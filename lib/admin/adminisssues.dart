import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sihwaterresq/admin/screens/adminmap.dart';

class adminissues extends StatefulWidget {
  const adminissues({super.key});

  @override
  State<adminissues> createState() => _adminissuesState();
}

class _adminissuesState extends State<adminissues> {
  var flag = 0;
  var pathoffile;
  Future<void> getdata() async {
    const _credentials = {
      "type": "service_account",
      "project_id": "sihproject-829f6",
      "private_key_id": "39de11b5b40609a93973eb761c7c1e7d9276d13c",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwcE+jlEBDpHiG\nWkX84qsKqrMjXPRqRxDFG8iG7l+m7w1oWGXEoD6z61mVS7IeB2cOLUJZYYc330vb\nbkdFNmuWpy7nJIZmSf3SKMxaVB/AcUYlOKeRuw8av0wUsZO3zsYRfN3yWmD4a9ek\nRZLdLF5BuU9zmOC3Wkz8rRyuQHqDO+bc9QRkha0V62UwCMBNfZgJOOSNbLxeryy3\nenPGEHYfJnog2E80zhnMPvgCO1ooSkFcqa5LlLD1y1jbjFYL6Qbelop9vMgjQm/K\nmUFDHReU+U3wW+8vx2Te7r8/iv0ixUX1XPVBWKQFsGisLb9SAb/Wk/ETXCw/YS3r\n+eD5HfppAgMBAAECggEAC8yMRtrUgVwvrdcTnxm5aSPeiZrfGCGwfr32PFpsjclR\naDehIUkQvbobajR/BisQj+N5mxM+llSZyg7R4qWvrt93RNXYdwwJAVOLzEPxQPlS\nQOL3sciEoLvyO+AJijKLDwL+r1pZPxkBzrvTBR9ryOa6PXdtGlXbmCTWKiuoWxDl\n5a1gwhRqcyQPQhn2OTWvQLJkCx2qY1j3vBVQ2DeNe3aD9wlcUbFOiChmbhI//Waa\nqsZHYNGH7ku+26ji47XjEDs2l82CievHeSqK37yRugX8W8XgvVgehZHlYVLhCNO3\nysR3ymrq7kDKd1+pN0R+qJiFbOduMOWAYY2P2/Cm0QKBgQDoy1GjIDPsbIVUhc4w\n+c9bMtWm/8qr/2K53G8zHjkmP3eYqGE4c5idjWmkFyMghfRJBGqQ5ub/GHMgiBt/\nSmok/fnEgSNmPXZ5bf8X1nEcrdHc2Jey7da7u8d94flaasDPhcVtjWUFcH1JQzIH\nSgbacELoUlauSwc51w84QszsowKBgQDCBtrYiWkWH/H1M7K2tLpITYelcD/YFPVa\nBxBqn2gTBu+ic2c9DOTJL42GUdwime3CXpPhjec0y5s1ooGrG1Omt/sAiLQxaPip\n02k/zKfYP+ENdMiRHfxtxR/q9iAtwaGD/4DzUuhTW5U2dCboxTZxDqsumXwo9yxR\nSNQleF7BgwKBgAC7UuBeY4tks+6WFRXWUy6INF+4Ah0USm0nIjpY5/kUzf1u2g9h\nXaNxJFndsMCTazcnimY2M5etrf72Lo/x3e+L1NMnTMMvgkXTcK/UfrqGWViGXcO0\nN66TYockxLHiEAUW+I3lmeGwftRSH8AiHW9mVu+AAsG9fqJR6LxWiWpdAoGBAJup\nKDYEt7w6UMGpgj02bSTInoTJs07GMbjSZgdEcBijvekUsMS37WzCq8YRMozH9Ym0\nmuugDte6aYD0KRd/SvM8MzFQe1AQqT6GD7BRnm7NgN5szOQvrG7ccSjt4Q8Ug2IE\nwA12fFEz7lfLg9PHNFArtoYiOQwckP99cEXHdi3FAoGAe2bVI5jFI0tvAPKbeiFe\n+eHdlcKbi3BXkYmEVDD2t4CJvuDxa64mXDS3bTn1acOHmm47J80X5aYVnlupU0/e\nfilyNMhigN6Bli0W593WWknafaljReygZ4sSeeveb/UeILegG1OG/9vBr1hls9Ql\n+01D2rXrsAZVxdXKgeK+yAQ=\n-----END PRIVATE KEY-----\n",
      "client_email": "gsheets@sihproject-829f6.iam.gserviceaccount.com",
      "client_id": "111320702935870803383",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40sihproject-829f6.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    const _spreadsheetId = '1Rx3zOEPQEXocREZWPYVNebPuOindXz-P6wU4ec8ibX4';

    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('Sheet1');
    if (sheet == null){
      sheet = await ss.addWorksheet('e');
    }
    final dbRef = FirebaseDatabase.instance.reference().child('feed');
    dbRef.once().then((DatabaseEvent event) async {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      for (var entry in values.entries) {
        var key = entry.key;
        var value = entry.value;
        List<String> row = [
          value['timestamp'].toString(),
          value['username'],
          value['photoUrl'],
          value['address'],
          value['latitude'].toString(),
          value['longitude'].toString(),
          value['description'],
          value['prediction'],
          value['selectedValue'],
          value['date'],
          value['time'],
          value['solved'],
        ];
        if (sheet != null && sheet.values != null) {
          await sheet.values.appendRow(row);
        }
      }
    });
    var url =
        'https://docs.google.com/spreadsheets/d/1Rx3zOEPQEXocREZWPYVNebPuOindXz-P6wU4ec8ibX4/export?format=xlsx';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      var file = File('${dir.path}/spreadsheet.xlsx');
      await file.writeAsBytes(bytes);
      print('Downloaded Google Sheet as Excel to ${dir.path}/spreadsheet.xlsx');
      setState(() {
        flag = 1;
        pathoffile =
            'Downloaded Google Sheet as Excel to ${dir.path}/spreadsheet.xlsx';
      });
    } else {
      throw Exception('Failed to download Google Sheet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
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
                    description:
                        'Drainage leaks are impacting these locations!',
                  ),
                  buildCard(
                    imagePath: 'assets/infra.png',
                    title: 'Infrastructure Damages',
                    description:
                        'Identified infrastructure damages in these areas!',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getdata();
                    },
                    child: Text("get data"),
                  ),
                  flag == 0 ? Container() : Text(pathoffile),
                ],
              ),
            ],
          ),
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
