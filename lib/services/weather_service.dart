import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather2_app/model/Weather.dart';

class WeatherService {
  static const String BASE_URL_CURRENT =
      "https://api.openweathermap.org/data/2.5/weather";
  static const String BASE_URL_FORECAST =
      "https://api.openweathermap.org/data/2.5/forecast";

  final String apiKey;

  WeatherService({required this.apiKey});

  // 🌤️ الطقس الحالي فقط
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL_CURRENT?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  // 🌦️ الطقس مع التوقعات (5 أيام كل 3 ساعات)
  Future<Weather> getWeatherWithForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL_FORECAST?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final city = data['city'];
      final List forecasts = data['list'];

      // أول عنصر يمثل الحالة الحالية
      final current = forecasts[0];

      // ⛅ إنشاء Weather رئيسي (الطقس الحالي)
      final currentWeather = Weather(
        cityName: city['name'],
        countryName: city['country'],
        tempareture: (current['main']['temp'] as num).toDouble(),
        mainCondition: current['weather'][0]['main'],
        minTemperature: (current['main']['temp_min'] as num).toDouble(),
        maxTemperature: (current['main']['temp_max']as num).toDouble(),
        feelsLike: (current['main']['feels_like'] as num).toDouble(),
        humidity: current['main']['humidity'],
        pressure: current['main']['pressure'],
        windSpeed: (current['wind']['speed'] as num).toDouble(),
        datetime: DateTime.fromMillisecondsSinceEpoch(current['dt'] * 1000),

        // هنا نحول كل forecast إلى Weather صغير
        hourlyForecast: forecasts.map((f) {
          return Weather(
            cityName: city['name'],
            countryName: city['country'],
            tempareture: (f['main']['temp'] as num).toDouble(),
            mainCondition: f['weather'][0]['main'],
            minTemperature: (f['main']['temp_min'] as num).toDouble(),
            maxTemperature: (f['main']['temp_max']as num).toDouble(),
            feelsLike: (f['main']['feels_like'] as num).toDouble(),
            humidity: f['main']['humidity'],
            pressure: f['main']['pressure'],
            windSpeed: (f['wind']['speed'] as num).toDouble(),

            datetime: DateTime.fromMillisecondsSinceEpoch(f['dt'] * 1000),
          );
        }).toList(),
      );

      return currentWeather;
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  // 📍 جلب اسم المدينة الحالية من الموقع الجغرافي
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city =
        placemarks[0].subAdministrativeArea ??
        placemarks[0].locality ??
        placemarks[0].country;

    return city ?? "";
  }

  
}
