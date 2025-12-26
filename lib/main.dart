import 'package:flutter/material.dart';
import 'screens/todo/todo_list_screen.dart';
import 'screens/shopping/shopping_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Materi 9',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade800, Colors.indigo.shade500],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_turned_in_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Task Manager Pro",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Materi 9 - Persistent Storage",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            _buildMenuCard(
              context,
              "Todo List App",
              "Kelola tugas harianmu",
              Icons.checklist_rounded,
              const TodoListScreen(),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              "Shopping List",
              "Daftar belanjaan terorganisir",
              Icons.shopping_bag_outlined,
              const ShoppingListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String sub, IconData icon, Widget target) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Icon(icon, color: Colors.indigo),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sub),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
        ),
      ),
    );
  }
}