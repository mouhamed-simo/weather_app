
class Weather {
  final String cityName;
  final String countryName;
  final double tempareture;
  final double minTemperature;
  final double maxTemperature;
  final String mainCondition;
  final DateTime datetime;
  final List<Weather>? hourlyForecast;
  final double feelsLike;
  final double windSpeed;
  final int humidity;
  final int pressure;
 
  Weather({
    required this.cityName,
    required this.countryName,
    required this.tempareture,
    required this.minTemperature,
    required this.maxTemperature,
    required this.mainCondition,
    required this.datetime,
    this.hourlyForecast,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      tempareture: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      countryName: json['sys']['country'],
      minTemperature: (json['main']['temp_min'] as num).toDouble(),
      maxTemperature: (json['main']['temp_max'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
       windSpeed: (json['wind']['speed'] as num).toDouble(),
      datetime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
