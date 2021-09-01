class Task {
  final int id;
  final String task;
  final DateTime dateTime;

  Task({this.id, this.task, this.dateTime});

  Map<String, dynamic> toMap() {
    return ({'id': id, 'task': task, 'creationDate': dateTime.toString()});
  }
}
