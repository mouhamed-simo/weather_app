import 'package:flutter/material.dart';
import 'package:weather2_app/model/details.dart';
import 'package:weather2_app/utils/app_textstyles.dart';
import 'package:weather2_app/utils/app_theme.dart';

class DetailsItems extends StatelessWidget {
  final Details details;
  const DetailsItems({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(details.icon, size: 28, color: ThemeColors.primaryColor,),
        const SizedBox(width: 8,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              details.value,
              style: AppTextstyles.bodySmall,
            ),
            Text(
              details.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }
}