import 'package:flutter/material.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/data/repo/todo_repo.dart';

class TodoChangeNotifier extends ChangeNotifier {
  final TodoRepository? todoRepository;
  TodoChangeNotifier({this.todoRepository});

  final List<Todo> _taskList = [];
  List<Todo> get taskList => _taskList;

  Future<void> getTaskList({String? filter}) async {
    var data = await todoRepository!.getTaskList(filter);
    _taskList.clear();
    _taskList.addAll(data.data);
    notifyListeners();
  }

  Future<void> insertTodo(Todo todo) async {
    await todoRepository!.insertTodo(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await todoRepository!.updateTodo(todo);
  }

  Future<void> removeTodo(Todo todo) async {
    await todoRepository!.removeTodo(todo);
    removeFromList(todo);
    notifyListeners();
  }

  void removeFromList(Todo todo) {
    _taskList.removeWhere((element) => element.id == todo.id);
  }
}
