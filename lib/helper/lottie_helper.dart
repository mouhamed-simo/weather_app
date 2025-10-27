// lib/utils/lottie_helper.dart
String getLottie(String? mainCondition) {
  if (mainCondition == null) return 'assets/lottie/sunny.json';
  
  switch (mainCondition.toLowerCase()) {
    case "clear":
    case "sunny":
      return 'assets/lottie/sunny.json';
    case "partly cloudy":
    case "few clouds":
    case "scattered clouds":
    case "broken clouds":
    case "clouds":
    case "overcast clouds":
      return 'assets/lottie/partly_cloudy.json';
    case "mist":
    case "smoke":
    case "haze":
    case "fog":
      return 'assets/lottie/windy.json';
    case "rain":
    case "light rain":
    case "moderate rain":
    case "drizzle":
      return 'assets/lottie/rain.json';
    case "thunderstorm":
      return 'assets/lottie/storm.json';
    case "snow":
      return 'assets/lottie/snow.json';
    default:
      return 'assets/lottie/sunny.json';
  }
}
