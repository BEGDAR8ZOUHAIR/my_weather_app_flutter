import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app/common/custom_painter.dart';
import 'package:weather_app/common/get_location_by_city.dart';
import 'package:weather_app/common/images_weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  String city = "";
  Map<String, dynamic>? weather;

  @override
  void initState() {
    super.initState();
    getCityAndWeather();
  }

  void getCityAndWeather() async {
    try {
      final position = await determinePosition();
      final cityName = await getCityFromLocation(position);

      if (cityName != null) {
        setState(() {
          city = cityName;
          print("Detected city=======================: $city");
        });
        getWeather();
      } else {
        getWeather();
      }
    } catch (e) {
      print("Location error: $e");
      getWeather();
    }
  }

  void getWeather() async {
    try {
      final data = await _weatherService.fetchWeather(city);
      setState(() {
        weather = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weather == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 🌤️ Gradient Sky Background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF81D4FA),
                        Color(0xFF2196F3),
                        Color(0xFF1976D2),
                      ],
                    ),
                  ),
                ),

                // 🌡️ Weather Info
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        // 🏙️ City Name
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${(weather!['main']['temp'] as num).toStringAsFixed(0)}°",
                          style: const TextStyle(
                            fontSize: 110,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1, // Increase line height
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 0),
                        Text(
                          weather!['weather'][0]['description'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🧊 Draggable Curved Bottom Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        // 🎨 Curved background using CustomPaint
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 100),
                          painter: CurvePainter(),
                        ),

                        // ⬆️ Drag handle
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 7,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        // 📄 Sheet content
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              controller: scrollController,
                              // scrollDirection: Axis.horizontal,c
                              children: _buildWeatherSlots(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }

  List<Widget> _buildWeatherSlots() {
    if (weather == null) return [];

    final temp = weather!['main']['temp'] as num;
    final description = weather!['weather'][0]['description'];

    final List<Map<String, dynamic>> timeSlots = [
      {
        'time': 'Morning',
        'temp': '${temp.toStringAsFixed(0)}°C',
        'image': getWeatherImage(description),
      },
      {
        'time': 'Afternoon',
        'temp': '${(temp + 1).toStringAsFixed(0)}°C',
        'image': getWeatherImage('clouds'),
      },
      {
        'time': 'Evening',
        'temp': '${(temp - 1).toStringAsFixed(0)}°C',
        'image': getWeatherImage('clear'),
      },
      {
        'time': 'Night',
        'temp': '${(temp - 2).toStringAsFixed(0)}°C',
        'image': getWeatherImage('rain'),
      },
    ];

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: timeSlots.map((slot) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  slot['image'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                slot['time'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                slot['temp'],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }).toList(),
      ),
      const SizedBox(height: 20),
    ];
  }
}
