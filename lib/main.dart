import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather2_app/services/weather_service.dart';
import 'package:weather2_app/view/splash_screen.dart';
import 'package:weather2_app/viewmodels/weather_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            WeatherService(apiKey:'dae7415142324f67725ee28e231c0c5c'),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo', home: SplashScreen());
  }
}
