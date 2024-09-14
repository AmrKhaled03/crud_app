import 'package:crud/constants/colors.dart';
import 'package:crud/constants/strings.dart';
import 'package:crud/controllers/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TasksController tasksController = TasksController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Function to load tasks and navigate to home screen
  Future<void> loadTasks() async {
    tasksController.getTasks();
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppStrings.homeRoute,
          arguments: tasksController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.appTitle.toString().toUpperCase(),
                    style: TextStyle(
                      color: AppColors.firstcolor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: SizedBox(
          height: 200,
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.firstcolor,
            size: 50,
          ),
        ),
      ),
    );
  }
}
