import 'package:crud/constants/colors.dart';
import 'package:crud/constants/extensions.dart';
import 'package:crud/constants/strings.dart';
import 'package:crud/controllers/tasks_controller.dart';
import 'package:crud/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TasksController tasksController;
  final TextEditingController title = TextEditingController();
  final TextEditingController subTitle = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController searchValue = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tasksController =
        ModalRoute.of(context)!.settings.arguments as TasksController;
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) async {
                    setState(() {
                      value = searchValue.text;
                    });
                    await tasksController.handleSearch(title: value);
                    setState(() {});
                  },
                  controller: searchValue,
                  style: TextStyle(color: AppColors.firstcolor),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.firstcolor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppColors.firstcolor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppColors.firstcolor),
                    ),
                    labelText: "Search Task ",
                    labelStyle: TextStyle(color: AppColors.firstcolor),
                    hintText: "Search Task",
                    hintStyle: TextStyle(color: AppColors.firstcolor),
                  ),
                ),
                20.gap,
                tasksController.tasks.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.firstcolor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Text(
                          "No Tasks Found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          TasksModel task = tasksController.tasks[index];
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            tileColor: AppColors.firstcolor,
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                task.isCompleted == 0
                                    ? Icons.close
                                    : Icons.check,
                                color: AppColors.firstcolor,
                                size: 50,
                              ),
                            ),
                            title: Text(
                              task.title.toString().toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 25),
                            ),
                            subtitle: Text(
                              overflow: TextOverflow.ellipsis,
                              task.subTitle.toString().toLowerCase(),
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.9),
                                  fontSize: 20),
                            ),
                            trailing: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: AppColors.firstcolor,
                              onSelected: (String value) async {
                                switch (value) {
                                  case 'Edit':
                                    openBottomSheet(task: task);
                                    break;
                                  case 'Delete':
                                    await tasksController.deleteData(
                                        id: task.id!);
                                    setState(() {});

                                    break;
                                  case 'Open':
                                    Navigator.pushNamed(
                                        context, AppStrings.detailsRoute,
                                        arguments: task);
                                    break;
                                  default:
                                    debugPrint("No Action Found");
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return {'Edit', 'Delete', 'Open'}
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                      value: choice,
                                      child: Column(
                                        children: [
                                          Text(
                                            choice,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: 1.gap,
                                          )
                                        ],
                                      ));
                                }).toList();
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: tasksController.tasks.length,
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          autofocus: true,
          focusColor: AppColors.secondColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Colors.white, width: 5)),
          onPressed: () {
            openBottomSheet();
          },
          backgroundColor: AppColors.secondColor,
          child: const Icon(
            size: 30,
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void openBottomSheet({TasksModel? task}) {
    title.text = task?.title ?? "";
    subTitle.text = task?.subTitle ?? "";
    description.text = task?.description ?? "";
    bool isChecked = task?.isCompleted == 1;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task == null ? "Add Task" : "Update Task",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.gap,
              TextFormField(
                controller: title,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: "Enter Title",
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: "Title",
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              ),
              20.gap,
              TextFormField(
                controller: subTitle,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: "Enter Subtitle",
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: "Subtitle",
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              ),
              20.gap,
              TextFormField(
                controller: description,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: "Enter Description",
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: "Description",
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              ),
              20.gap,
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) async {
                      setState(() {
                        isChecked = value ?? false; // Update local variable
                      });
                    },
                    activeColor: Colors.transparent,
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text(
                    "Mark As Done Task",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              20.gap,
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.secondColor),
                  ),
                  onPressed: () async {
                    if (task == null) {
                      await tasksController.addData(
                        tasksController.tasks.length + 1,
                        title: title.text,
                        subTitle: subTitle.text,
                        description: description.text,
                        isCompleted: isChecked ? 1 : 0,
                      );
                      setState(() {});
                      Fluttertoast.showToast(
                        msg: "Task Added Successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      await tasksController.updateData(
                        id: task.id!,
                        title: title.text,
                        subTitle: subTitle.text,
                        description: description.text,
                        isCompleted: isChecked ? 1 : 0,
                      );
                      setState(() {}); // Update the UI
                      Fluttertoast.showToast(
                        msg: "Task Updated Successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: Text(
                    task == null ? "Add Task" : "Update Task",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      backgroundColor: AppColors.firstcolor,
    );
  }
}
