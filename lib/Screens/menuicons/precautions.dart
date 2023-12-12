// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Precautions extends StatefulWidget {
  const Precautions({Key? key}) : super(key: key);

  @override
  State<Precautions> createState() => _PrecautionsState();
}

class _PrecautionsState extends State<Precautions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 177, 216, 255),
        appBar: AppBar(
          title: const Text(
            'Precaution', // You need to define 'category'
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              // padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToSecondPage(
                    context,
                    categories[index]['name'] as String,
                    categories[index]['videos'] as List<Map<String, String>>,
                  );
                },

                child: Text(
                  categories[index]['name'] as String,
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
                // style: ElevatedButton.styleFrom(
                //   minimumSize: Size(350, 130),
                // ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToSecondPage(
      BuildContext context, String category, List<Map<String, String>> videos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondPage(category: category, videos: videos),
      ),
    );
  }
}

var categories = [
  {
    'name': 'Flood',
    'videos': [
      {
        'title': 'Flood precautions for kids',
        'videoUrl': 'https://youtube.com/watch?v=pi_nUPcQz_A&feature=shared',
        'imageUrl':
            'https://media.istockphoto.com/id/1750573157/vector/scared-man-on-house-roof-flat-concept-vector-spot-illustration.jpg?s=612x612&w=0&k=20&c=lKK6N8tKReg6JK8MH5R8lol4xgL5ZkPLM7clJYuZrrw=',
        'des':
            'How To Survive Floods? | Disaster Management | Preparing For A Flood | Natural Disaster | Safety Tips | How To Escape A Flood | Flood Management | Flood Protection',
      },
      {
        'title': 'Flood precautions for adults',
        'videoUrl': 'https://youtu.be/7kWkmblakT8?si=2Wad2CS66rTTrB91',
        'imageUrl': 'https://i.ytimg.com/vi/43M5mZuzHF8/maxresdefault.jpg',
        'des':
            'Explore vital flood preparedness strategies—evacuation plans, emergency kits, and crucial tips for safeguarding your family and property',
      },
    ],
  },
  {
    'name': 'Tsunami',
    'videos': [
      {
        'title': 'Tsunami precautions for kids',
        'videoUrl': 'https://youtu.be/m7EDddq9ftQ?si=YSZLMKl8c4MpeAi3',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwzvVQwnzWDKkXt2FfcDleIeSl65_bHzB_-g&usqp=CAU',
        'des':
            'Dive into this comprehensive guide on tsunami preparedness. Learn evacuation strategies, emergency kits, and essential tips for staying safe. Watch now!',
      },
      {
        'title': 'Tsunami precautions for adults',
        'videoUrl': 'https://youtu.be/7EDflnGzjTY?si=oHvJY_LocfedaO9X',
        'imageUrl':
            'https://i.ndtvimg.com/i/2018-02/tsunami-generic_650x400_41517969992.jpg',
        'des':
            'Unlock the secrets of tsunami survival with this science-backed guide. Explore expert insights, evacuation techniques, and life-saving strategies. Watch now for essential knowledge in the face of danger.',
      },
    ]
  },
  {
    'name': 'Earthquake',
    'videos': [
      {
        'title': 'EarthQuake precautions for kids',
        'videoUrl': 'https://www.youtube.com/watch?v=MllUVQM3KVk',
        'imageUrl':
            'https://www.piyon.co/issue-3/what-is-an-earthquake/earthquake-moment.jpg',
        'des':
            'Join Dr. Binocs on an adventure to discover earthquake safety tips. Learn essential survival strategies in this engaging and educational video for kids. Stay prepared with Peekaboo Kidz!',
      },
      {
        'title': 'EarthQuake precautions for adults',
        'videoUrl': 'https://youtu.be/hWSu4l1RxLg?si=ZK2gHaPOMDr3MUrb',
        'imageUrl':
            'https://www.earthquakeauthority.com/EQA2/media/Image/Blog/things-to-do-after-an-earthquake.png',
        'des':
            'Discover expert-backed strategies to navigate earthquake survival. Uncover the top 10 ways to stay safe and resilient during seismic events. Essential tips for preparedness and well-being.',
      },
    ]
  },
  {
    'name': 'Hurricane',
    'videos': [
      {
        'title': 'Hurricanes precautions for kids',
        'videoUrl': 'https://youtu.be/J2__Bk4dVS0?si=Ra0OLCKh92ALadHp',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl0l1R7ERhvmlmRVK_ugkwg1IIT97pcXrw6Q&usqp=CAU',
        'des':
            'Explore the fascinating world of hurricanes with educational videos designed for young minds. Learn about these powerful natural phenomena through engaging and informative content',
      },
      {
        'title': 'Hurricanes precautions for adults',
        'videoUrl': 'https://youtu.be/fuuSm2WzJZo?si=Mcm2l9w1u_DfO_wj',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsavQZgCw78b1oo9x4BfYvCTteHGCjjc3Txw&usqp=CAU',
        'des':
            'Gain life-saving insights with this guide on surviving hurricanes. Discover essential tips and strategies to protect yourself and your loved ones during these powerful storms',
      },
    ]
  },
  {
    'name': 'First Aid tips',
    'videos': [
      {
        'title': ' First Aid Training',
        'videoUrl': 'https://youtu.be/gn6xt1ca8A0?si=B69zwrJDSqqlVQ6z',
        'imageUrl':
            'https://niragashospital.com/wp-content/uploads/2018/08/Product-01.jpg',
        'des':
            'Unlock the power of your first aid kit with expert guidance. Learn essential skills and explore the contents for effective first aid in emergencies. Watch now for valuable training!',
      },
      {
        'title': 'CPR: Simple steps to save a life',
        'videoUrl': 'https://youtu.be/8YREVVM2n7g?si=mz9HHQE22qc0eMU7',
        'imageUrl':
            'https://i.pinimg.com/originals/1c/af/98/1caf98355a8d5e23b0cb1b92ec9f8dc4.jpg',
        'des':
            'Master the art of saving lives with CPR. This video provides simple steps and crucial techniques to empower you in performing effective cardiopulmonary resuscitation.',
      },
    ]
  },
];

class SecondPage extends StatelessWidget {
  final String category;
  final List<Map<String, String>> videos;

  SecondPage({required this.category, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Precaution - $category',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 51, 83),
      ),
      body: Container(
        color: const Color.fromARGB(255, 177, 216, 255),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Card(
              // color: const Color.fromARGB(255, 177, 216, 255),
              elevation: 3,
              margin: const EdgeInsets.all(15),
              child: ListTile(
                //tileColor: Color.fromARGB(255, 176, 192, 208),
                leading: Image.network(
                  videos[index]['imageUrl'] ??
                      'https://cdn.oneesports.gg/cdn-data/2022/03/GenshinImpact_Mtashed_Son_featured-1.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  videos[index]['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  videos[index]['des'] ?? 'tellod', // Use your own description
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  _playVideo(context, videos[index]['videoUrl']!);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _playVideo(BuildContext context, String videoUrl) {
    // Extract video ID from the YouTube URL using a regular expression
    RegExp regExp = RegExp(
      r'^(?:(?:https?:)?\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );

    Match? match = regExp.firstMatch(videoUrl);

    if (match != null) {
      String videoId = match.group(1)!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoId: videoId),
        ),
      );
    } else {
      // Handle the case when the video ID couldn't be extracted
      print('Invalid YouTube URL');
      // You may want to show a user-friendly message or handle it differently
    }
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onEnded: (YoutubeMetaData metaData) {
              // Video has ended, set preferred orientation to portrait
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
          ),
          builder: (context, player) {
            return Column(
              children: [
                // Your additional UI elements can be added here
                Expanded(
                  child: player,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
