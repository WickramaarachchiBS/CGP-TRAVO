import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'b0119b5d1b011b6e41147f6aad584906';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
