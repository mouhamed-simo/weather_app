import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather2_app/helper/lottie_helper.dart';
import 'package:weather2_app/model/Weather.dart';
import 'package:weather2_app/utils/app_textstyles.dart';
import 'package:weather2_app/utils/app_theme.dart';

class HourlyWeather extends StatelessWidget {
  final List<Weather> forecastList;
  final int selectedIndex; // 0=Yesterday, 1=Today, 2=Tomorrow

  const HourlyWeather({
    super.key,
    required this.forecastList,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<WeatherViewModel>(context);
    if (forecastList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    //  نحسب التاريخ حسب الاختيار
    DateTime targetDate = DateTime.now().add(Duration(days: selectedIndex - 1));

    //  نفلتر التوقعات لليوم المختار فقط
    final filtered = forecastList
        .where(
          (w) =>
              w.datetime.day == targetDate.day &&
              w.datetime.month == targetDate.month,
        )
        .toList();

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final weather = filtered[index];
          final time = DateFormat('h a').format(weather.datetime);

          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  time,
                  style: AppTextstyles.withColor(
                    AppTextstyles.bodySmall,
                    ThemeColors.titleColor,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Lottie.asset(getLottie(weather.mainCondition)),
                ),
                Text(
                  '${weather.tempareture.toStringAsFixed(0)}°C',
                  style: AppTextstyles.withColor(
                    AppTextstyles.bodySmall,
                    Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
