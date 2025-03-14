import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the first time ever opening this app
  void createInitialData() {
    toDoList = [
      ["welcome to reminder", false]
    ];
  }

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}
