import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
