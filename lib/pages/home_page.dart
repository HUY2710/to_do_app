import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

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
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();
  String error = "";
  void onSave() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.data.add([_controller.text, false]);
        _controller.clear();
      });
      Navigator.of(context).pop();
    }
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller: _controller,
              onSave: onSave,
              onCancel: () => Navigator.of(context).pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("TO DO"),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: GestureDetector(
        onTap: createNewTask,
        child: Container(
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Have a beautiful day!",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color.fromARGB(255, 6, 54, 136)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(formattedDate,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 6, 54, 136))),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: db.data.length,
                  itemBuilder: (context, index) {
                    return ToDoTile(
                      taskName: db.data[index][0],
                      taskCompleted: db.data[index][1],
                      onChanged: (value) {
                        setState(() {
                          db.data[index][1] = !db.data[index][1];
                        });
                        db.updateDataBase();
                      },
                      onTap: () {
                        setState(() {
                          setState(() {
                            db.data.removeAt(index);
                          });
                          db.updateDataBase();
                        });
                      },
                    );
                  }),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
