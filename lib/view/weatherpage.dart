import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather2_app/helper/lottie_helper.dart';
import 'package:weather2_app/utils/app_theme.dart';
import 'package:weather2_app/view/Widget/details_weather.dart';
import 'package:weather2_app/view/Widget/hourly_weather.dart';
import 'package:weather2_app/view/Widget/section_days.dart';
import 'package:weather2_app/view/Widget/week_data.dart';
import 'package:weather2_app/viewmodels/weather_viewmodel.dart';
import 'package:weather2_app/utils/app_textstyles.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherViewModel>(context, listen: false)
          .fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WeatherViewModel>(context);

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.weather == null) {
      return const Scaffold(
        body: Center(child: Text("No data found")),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: ThemeColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${vm.weather?.cityName}, ${vm.weather?.countryName}',
                style: AppTextstyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                color: ThemeColors.primaryColor,
                child: Center(
                  child: Lottie.asset(
                    getLottie(vm.weather!.mainCondition),
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    vm.weather!.mainCondition,
                    style: AppTextstyles.withColor(
                      AppTextstyles.h2,
                      ThemeColors.titleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    DateFormat('EEE, d MMMM yyyy')
                        .format(vm.weather?.datetime ?? DateTime.now()),
                    style: AppTextstyles.withColor(
                      AppTextstyles.bodyMeduim,
                      ThemeColors.titleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  const SectionDays(),
                  const SizedBox(height: 25),

                  HourlyWeather(
                    forecastList: vm.weather!.hourlyForecast ?? [],
                    selectedIndex: vm.selectedIndex,
                  ),
                 

                  const DetailsWeather(),
                  const SizedBox(height: 30),

                  const WeekData(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
