import 'package:crud/constants/colors.dart';
import 'package:crud/constants/extensions.dart';
import 'package:crud/constants/strings.dart';
import 'package:crud/models/tasks_model.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    TasksModel task = ModalRoute.of(context)!.settings.arguments as TasksModel;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/logo.png"),
            radius: 40,
          ),
        ),
        title: Text(
          AppStrings.appTitle.toString().toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.firstcolor,
                  radius: 100,
                  child: Icon(
                    task.isCompleted == 1 ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                20.gap,
                Text(
                  task.title.toString().toUpperCase(),
                  style: TextStyle(
                      color: AppColors.firstcolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                20.gap,
                Text(
                  task.subTitle.toString().toLowerCase(),
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                20.gap,
                Text(
                  task.description.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                20.gap,
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.firstcolor)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back To Tasks",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
