import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder_hive/data/database.dart';
import 'package:reminder_hive/util/dailog_box.dart';
import 'package:reminder_hive/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the first time ever opening the app. then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final TextEditingController _controller =
      TextEditingController(); // Explicitly typed

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  // Function to save a new task
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([_controller.text, false]); // Add task to list
      });
      _controller.clear(); // Clear the controller after saving
      Navigator.of(context).pop(); // Close the dialog
      db.updateData();
    }
  }

  // Show the dialog to add a new task
  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DailogBox(
          controller: _controller, // Pass the controller here
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog on cancel
            _controller.clear(); // Clear the controller on cancel
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: const Text(
            'REMINDER',
            style: TextStyle(color: Colors.white, fontFamily: 'lexand'),
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog, // Trigger dialog on press
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
