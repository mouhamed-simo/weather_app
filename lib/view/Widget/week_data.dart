import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather2_app/helper/lottie_helper.dart';
import 'package:weather2_app/model/Weather.dart';
import 'package:weather2_app/viewmodels/weather_viewmodel.dart';

class WeekData extends StatelessWidget {
  const WeekData({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WeatherViewModel>(context);
    final List<Weather>? forecast = vm.getWeeklyForecast();

    if (forecast == null || forecast.isEmpty) {
      print(" errorrrr : $forecast");
      return const Center(child: Text('No forecast data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          vm.weather!.mainCondition,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormat(
            'EEE, d MMMM yyyy',
          ).format(vm.weather?.datetime ?? DateTime.now()),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120, // slightly taller for Lottie
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length >= 7 ? 7 : forecast.length,
            itemBuilder: (context, index) {
              final dayWeather = forecast[index];
              final dayName = DateFormat('EEE').format(dayWeather.datetime);
              final maxTemp = dayWeather.maxTemperature.toStringAsFixed(0);
              final minTemp = dayWeather.minTemperature.toStringAsFixed(0);

              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(8),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(getLottie(dayWeather.mainCondition)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$maxTemp°C / $minTemp°C',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
