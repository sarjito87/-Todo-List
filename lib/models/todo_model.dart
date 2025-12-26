class Todo {
  String id;
  String task;
  bool isCompleted;

  Todo({required this.id, required this.task, this.isCompleted = false});

  Map<String, dynamic> toMap() => {'id': id, 'task': task, 'isCompleted': isCompleted};

  factory Todo.fromMap(Map<String, dynamic> map) =>
      Todo(id: map['id'], task: map['task'], isCompleted: map['isCompleted']);
}