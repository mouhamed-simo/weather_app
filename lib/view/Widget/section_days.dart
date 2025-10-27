import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather2_app/utils/app_textstyles.dart';
import 'package:weather2_app/utils/app_theme.dart';
import 'package:weather2_app/viewmodels/weather_viewmodel.dart';

class SectionDays extends StatelessWidget {
  const SectionDays({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WeatherViewModel>(context);
    List<String> dayNames = ["Yesterday", "Today", "Tomorrow"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(dayNames.length, (index) {
        bool isSelected = vm.selectedIndex == index;
        return GestureDetector(
          onTap: () => vm.changeDay(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        ThemeColors.primaryColor,
                        ThemeColors.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Text(
              dayNames[index],
              style: AppTextstyles.withColor(
                AppTextstyles.buttonSmall,
                isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
