import 'package:crud/constants/strings.dart';
import 'package:crud/views/screens/details.dart';
import 'package:crud/views/screens/home.dart';
import 'package:crud/views/screens/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:AppStrings.appTitle,
      theme: ThemeData(
       

        useMaterial3: true,
        
      ),
   routes: {
    AppStrings.splashRoute : (context)=> const SplashScreen(),
    AppStrings.homeRoute:(context)=>const HomeScreen(),
    AppStrings.detailsRoute:(context)=>const DetailsScreen(),
   },
   initialRoute: AppStrings.splashRoute,
    );
  }
}


