import 'package:diary/db/db_provider.dart';
import 'package:flutter/material.dart';
import 'db/db_provider.dart';
import 'model/task_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // It is the root widget of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({Key key}) : super(key: key);

  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor = Color(0xFF0d0952);
  Color secondColor = Color(0xFF212061);
  Color btnColor = Color(0xFFff955b);
  Color editorColor = Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainColor,
        title: Text("My To-Do!"),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getTasks(),
            // ignore: missing_return
            builder: (_, taskData) {
              switch (taskData.connectionState) {
                case ConnectionState.waiting:
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                case ConnectionState.done:
                  {
                    if (taskData.data != Null) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: taskData.data.length,
                          itemBuilder: (context, index) {
                            String task =
                                taskData.data[index]['task'].toString();
                            String day = DateTime.parse(
                                    taskData.data[index]['creationDate'])
                                .day
                                .toString();
                            return Card(
                                color: secondColor,
                                child: InkWell(
                                    child: Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 12.0),
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(day,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(task,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0)),
                                    ),
                                  ),
                                ])));
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("You have no tasks today",
                            style: TextStyle(color: Colors.white54)),
                      );
                    }
                    // ignore: dead_code
                    break;
                  }
                case ConnectionState.none:
                  // TODO: Handle this case.
                  break;
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
              }
            },
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            decoration: BoxDecoration(
                color: editorColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type a new Task",
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      newTaskTxt = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask =
                        Task(task: newTaskTxt, dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                  icon: Icon(Icons.add),
                  color: btnColor,
                  label: Text("Add Task"),
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
