import 'package:flutter/material.dart';
import '../../../models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(bool?) onStatusChanged;
  final VoidCallback onEdit;

  const TodoItemWidget({super.key, required this.todo, required this.onStatusChanged, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: todo.isCompleted, onChanged: onStatusChanged),
      title: Text(todo.task, style: TextStyle(decoration: todo.isCompleted ? TextDecoration.lineThrough : null)),
      trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
    );
  }
}