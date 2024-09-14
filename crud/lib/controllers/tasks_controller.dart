import 'package:crud/constants/db.dart';
import 'package:crud/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TasksController {
  DBHelper dbHelper = DBHelper();
  List<TasksModel> tasks = [];

  // Fetch tasks from the database
  Future<void> getTasks() async {
    try {
      var data = await dbHelper.getData("SELECT * FROM Task");
      tasks = data.map<TasksModel>((task) {
        return TasksModel(
          task['id'],
          title: task['title'],
          subTitle: task['subTitle'],
          description: task['description'],
          isCompleted: task['isCompleted'] == 1 ? 1 : 0,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    }
  }

  // Add a new task to the database
  Future<void> addData(
    int id, {
    required String title,
    required String subTitle,
    required String description,
    required int isCompleted,
  }) async {
    if (title.isEmpty || subTitle.isEmpty || description.isEmpty) {
      Fluttertoast.showToast(
        msg: "Task Can't Be Empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Exit the function if any field is empty
    }

    try {
      await dbHelper.insertData(
        "INSERT INTO Task (title, subTitle, description, isCompleted) VALUES ('$title', '$subTitle', '$description', $isCompleted)",
      );
      await getTasks(); // Refresh task list
    } catch (e) {
      debugPrint("Error adding task: $e");
      Fluttertoast.showToast(
        msg: "Error Adding Task!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Delete a task from the database
 Future<void> deleteData({required int id}) async {
  try {
    await dbHelper.deleteData("DELETE FROM Task WHERE id = $id");
    tasks.removeWhere((task) => task.id == id);
    
    // Update UI
    Fluttertoast.showToast(
      msg: "Task Deleted Successfully!",
      toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    await getTasks();
  } catch (e) {
    debugPrint("Error deleting task: $e");
    Fluttertoast.showToast(
      msg: "Error Deleting Task!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

  // Update task in the database
  Future<void> updateData({
    required int id,
    required String title,
    required String subTitle,
    required String description,
    required int isCompleted,
  }) async {
    try {
      await dbHelper.updateDate(
        "UPDATE Task SET title = '$title', subTitle = '$subTitle', description = '$description', isCompleted = $isCompleted WHERE id = $id",
      );
      // Refresh task list
      await getTasks();
    } catch (e) {
      debugPrint("Error updating task: $e");
    }
  }

  // Handle task completion
  Future<void> handleCompleted(
     int? id,
     String? title,
     String? subTitle,
     String? description,
     bool? isCompleted,
  ) async {
    await updateData(
      id: id!,
      title: title!,
      subTitle: subTitle!,
      description: description!,
      isCompleted: isCompleted!  ? 1 : 0,
    );
  }

  // Handle search in database
  Future<void> handleSearch({required String title}) async {
    try {
      var data = await dbHelper.getData("SELECT * FROM Task WHERE title LIKE '%$title%'");
      tasks = data.map<TasksModel>((task) {
        return TasksModel(
          task['id'],
          title: task['title'],
          subTitle: task['subTitle'],
          description: task['description'],
          isCompleted: task['isCompleted'] == 1 ? 1 : 0,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error searching tasks: $e");
    }
  }
}
