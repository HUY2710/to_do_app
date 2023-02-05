import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List data = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    data = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }

  // load the data from database
  void loadData() {
    data = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", data);
  }
}
