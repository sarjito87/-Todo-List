import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo_model.dart';
import '../models/shopping_model.dart';

class StorageService {
  static const String _todoKey = 'todo_list';
  static const String _shopKey = 'shop_list';

  static Future<void> saveTodos(List<Todo> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todoKey, jsonEncode(list.map((e) => e.toMap()).toList()));
  }

  static Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_todoKey);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Todo.fromMap(e)).toList();
  }

  static Future<void> saveShopping(List<ShoppingItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopKey, jsonEncode(list.map((e) => e.toMap()).toList()));
  }

  static Future<List<ShoppingItem>> loadShopping() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_shopKey);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => ShoppingItem.fromMap(e)).toList();
  }
}