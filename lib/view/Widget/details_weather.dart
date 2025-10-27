import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather2_app/model/Weather.dart';
import 'package:weather2_app/model/details.dart';
import 'package:weather2_app/utils/app_textstyles.dart';
import 'package:weather2_app/view/Widget/details_items.dart';
import 'package:weather2_app/viewmodels/weather_viewmodel.dart';

class DetailsWeather extends StatelessWidget {
  const DetailsWeather({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WeatherViewModel>(context);
    Weather? selectedWeather=vm.getWeatherForSelectedDay();
    if(selectedWeather==null) return SizedBox.shrink();

    final List<Details> detailsList = [
      Details(
        icon: Icons.thermostat,
        value: "${selectedWeather.feelsLike.toStringAsFixed(0)}°C",
        title: "Feels Like",
      ),
       Details(
        icon: Icons.air,
        value: "${selectedWeather.windSpeed.toStringAsFixed(0)}m/s",
        title: "Wind",
      ),
       Details(
        icon: Icons.thermostat,
        value: "${selectedWeather.pressure}hPa",
        title: "Pressure ",
      ),
       Details(
        icon: Icons.water_drop,
        value: "${selectedWeather.humidity}%",
        title: "Humidity",
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: AppTextstyles.bodyLarge),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: [for (var item in detailsList) DetailsItems(details: item)],
        ),
      ],
    );
  }
}
