import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherApi {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  static const String apiKey =
      '89a03b522d55b4358857591de2d34a81'; // Replace with your API key

  Future<Map<String, dynamic>> getWeatherData(String location) async {
    try {
      final response = await _dio.get(
        '${baseUrl}weather',
        queryParameters: {'q': location, 'appid': apiKey, 'units': 'metric'},
      );

      return response.data;
    } catch (error, stacktrace) {
      print('Error fetching current weather data: $error');
      print(stacktrace);
      throw Exception('Failed to fetch current weather data');
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast(String location) async {
    try {
      final response = await _dio.get(
        '${baseUrl}forecast',
        queryParameters: {'q': location, 'appid': apiKey, 'units': 'metric'},
      );

      return response.data;
    } catch (error, stacktrace) {
      print('Error fetching weather forecast: $error');
      print(stacktrace);
      throw Exception('Failed to fetch weather forecast');
    }
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherApi weatherApi = WeatherApi();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("W E A T H E R"),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
          child: FutureBuilder<Map<String, dynamic>>(
            future: weatherApi.getWeatherData('chennai'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error fetching current weather data');
              } else {
                final weatherData = snapshot.data!;
                return FutureBuilder<Map<String, dynamic>>(
                  future: weatherApi.getWeatherForecast('delhi'),
                  builder: (context, forecastSnapshot) {
                    if (forecastSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (forecastSnapshot.hasError) {
                      return const Text('Error fetching weather forecast');
                    } else {
                      final forecastData = forecastSnapshot.data!;
                      return WeatherWidget(
                        currentTemperature: '${weatherData['main']['temp']}° C',
                        condition:
                            '${weatherData['weather'][0]['description']}',
                        minTemp: '${weatherData['wind']['speed']}',
                        maxTemp: '${weatherData['main']['pressure']}',
                        humidity: '${weatherData['main']['humidity']}%',
                        prediction: '${weatherData['main']['feels_like']}%',
                        iconCode: '${weatherData['weather'][0]['icon']}',
                        forecast: forecastData['list'],
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    Key? key,
    required this.currentTemperature,
    required this.condition,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.prediction,
    required this.iconCode,
    required this.forecast,
  }) : super(key: key);

  final String currentTemperature;
  final String condition;
  final String minTemp;
  final String maxTemp;
  final String humidity;
  final String prediction;
  final String iconCode;
  final List<dynamic> forecast;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  //   gradient: const LinearGradient(
                  //     colors: [
                  //       Color.fromARGB(255, 199, 201, 202),
                  //       Color.fromARGB(255, 183, 181, 181),
                  //       Color.fromARGB(255, 197, 231, 243),
                  //     ],
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //   ),
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      currentTemperature,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.cloud,
                        size: 160,
                      ),
                    ),
                    //SizedBox(height: 5),
                    Container(
                      height: 180,
                      width: 300,
                      padding:
                          const EdgeInsets.only(top: 25, left: 10, right: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 0, 0),
                            Color.fromARGB(255, 11, 51, 83),
                            Colors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Wind Speed: $minTemp m/s',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Wind Pressure: $maxTemp',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Humidity: $humidity',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Prediction: $prediction',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                forecast.length,
                (index) => WeatherContainer(
                  day: getDayOfWeek(index),
                  temperature: '${forecast[index]['main']['temp']}° C',
                  condition: '${forecast[index]['weather'][0]['description']}',
                  humidity: '${forecast[index]['main']['humidity']}%',
                  iconCode: '${forecast[index]['weather'][0]['icon']}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDayOfWeek(int index) {
    final now = DateTime.now();
    final date = now.add(Duration(days: index + 1));
    return DateFormat('EEEE').format(date);
  }
}

class WeatherContainer extends StatelessWidget {
  final String day;
  final String temperature;
  final String condition;
  final String humidity;
  final String iconCode;

  const WeatherContainer({
    Key? key,
    required this.day,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.iconCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 130,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 177, 216, 255),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 155, 155, 155).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            temperature,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            condition,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            humidity,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 5),
          Image.network(
            'https://openweathermap.org/img/w/$iconCode.png',
            scale: 1.5,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WeatherApp(),
  ));
}
