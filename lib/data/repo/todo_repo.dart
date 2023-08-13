import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/data/model/result.dart';

abstract class TodoRepository {
  Future<Result> insertTodo(Todo todo);
  Future<Result> updateTodo(Todo todo);
  Future<Result> removeTodo(Todo todo);
  Future<Result> getTodoById(String id);
  Future<Result> getTaskList(String? filter);
}
