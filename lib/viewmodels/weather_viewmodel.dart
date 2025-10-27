import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather2_app/model/Weather.dart';
import 'package:weather2_app/services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;
  Weather? _weather;
  bool _isLoading = false;
  List<Weather>? forecast;
  int _selectedIndex = 1; // 0=Yesterday, 1=Today, 2=Tomorrow

  WeatherViewModel(this._weatherService);

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  int get selectedIndex => _selectedIndex;

  //  تحميل الطقس الحالي + التوقعات
  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final weatherData = await _weatherService.getWeatherWithForecast(
        cityName,
      );
      _weather = weatherData;

      forecast = weatherData.hourlyForecast ?? [];
    } catch (e) {
      debugPrint('Error fetching weather: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🌀 جلب المدينة الحالية حسب الموقع
  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      String city = await _weatherService.getCurrentCity();
      await fetchWeather(city);
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔄 تبديل اليوم بين Yesterday / Today / Tomorrow
  void changeDay(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // 🔹 دالة ترجع التوقعات الخاصة باليوم المختار
  List<Weather> getDayForecast(int dayIndex) {
    if (forecast == null) return [];

    DateTime now = DateTime.now();
    DateTime targetDay;

    if (dayIndex == 0) {
      targetDay = now.subtract(Duration(days: 1)); // Yesterday
    } else if (dayIndex == 1) {
      targetDay = now; // Today
    } else {
      targetDay = now.add(Duration(days: 1)); // Tomorrow
    }

    return forecast!
        .where(
          (w) =>
              w.datetime.day == targetDay.day &&
              w.datetime.month == targetDay.month,
        )
        .toList();
  }

  Weather? getWeatherForSelectedDay() {
    List<Weather> data = getDayForecast(selectedIndex);
    if (data.isEmpty) return weather;
    return data.first;
  }

  List<Weather> getWeeklyForecast() {
    if (forecast == null) return [];

    // نجمع التوقعات حسب اليوم
    final Map<String, List<Weather>> grouped = {};

    for (var w in forecast!) {
      final key = DateFormat('yyyy-MM-dd').format(w.datetime);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(w);
    }

    // ناخدو يوم واحد من كل مجموعة
    final List<Weather> daily = grouped.entries.map((entry) {
      final dayList = entry.value;

      final maxTemp = dayList
          .map((e) => e.maxTemperature)
          .reduce((a, b) => a > b ? a : b);
      final minTemp = dayList
          .map((e) => e.minTemperature)
          .reduce((a, b) => a < b ? a : b);
      final mainCondition = dayList[0].mainCondition;

      return Weather(
        cityName: dayList[0].cityName,
        countryName: dayList[0].countryName,
        tempareture: dayList[0].tempareture,
        minTemperature: minTemp,
        maxTemperature: maxTemp,
        mainCondition: mainCondition,
        datetime: dayList[0].datetime,
        feelsLike: dayList[0].feelsLike,
        humidity: dayList[0].humidity,
        pressure: dayList[0].pressure,
        windSpeed: dayList[0].windSpeed,
      );
    }).toList();

    return daily.take(7).toList(); // غير أسبوع واحد
  }
}
