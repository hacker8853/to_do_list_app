import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider dataBase = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDataBase();
    return _database;
  }

  initDataBase() async {
    return await openDatabase(join(await getDatabasesPath(), 'todo_app_db.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE TASKS (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creatindate TEXT''');
    }, version: 1);
  }

  addNewTask(Task newTask) async {
    final db = await database;
    db?.insert("tasks", newTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getTask() async {
    final db = await database;
    var res = await db?.query("tasks");
    if (res?.length == 0) {
      return Null;
    } else {
      var resultMap = res?.toList();
      return resultMap!.isNotEmpty ? resultMap : Null;
    }
  }
}
