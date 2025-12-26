import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/todo_model.dart';
import '../../services/storage_service.dart';
import 'widgets/todo_item.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _allTodos = [];
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await StorageService.loadTodos();
    setState(() => _allTodos = data);
  }

  void _saveData() {
    StorageService.saveTodos(_allTodos);
  }

  List<Todo> get _filteredTodos {
    if (_filter == 'Selesai') return _allTodos.where((t) => t.isCompleted).toList();
    if (_filter == 'Belum Selesai') return _allTodos.where((t) => !t.isCompleted).toList();
    return _allTodos;
  }

  void _showForm([Todo? todo]) {
    final controller = TextEditingController(text: todo?.task ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(todo == null ? "Tambah Tugas" : "Edit Tugas"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Nama tugas...",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          if (todo != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() => _allTodos.removeWhere((t) => t.id == todo.id));
                _saveData();
                Navigator.pop(context);
              },
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.isEmpty) return;
              setState(() {
                if (todo == null) {
                  _allTodos.add(Todo(id: const Uuid().v4(), task: controller.text));
                } else {
                  todo.task = controller.text;
                }
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Filter menggunakan PopupMenuButton agar lebih clean daripada Dropdown standar
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.indigo),
            onSelected: (val) => setState(() => _filter = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Semua', child: Text('Semua')),
              const PopupMenuItem(value: 'Selesai', child: Text('Selesai')),
              const PopupMenuItem(value: 'Belum Selesai', child: Text('Belum Selesai')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Chip Indikator Filter Aktif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(_filter, style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.indigo,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Text("Belum ada tugas", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTodos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _filteredTodos[index];
                return TodoItemWidget(
                  todo: item,
                  onStatusChanged: (val) {
                    setState(() => item.isCompleted = val!);
                    _saveData();
                  },
                  onEdit: () => _showForm(item),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: () => _showForm(),
        label: const Text("Tambah"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}