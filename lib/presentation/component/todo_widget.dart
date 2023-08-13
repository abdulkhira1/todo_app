import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/provider/todo_provider.dart';
import 'package:todo_app/presentation/screen/add_data_screen.dart';
import 'package:todo_app/presentation/screen/todo_screen.dart';

class TodoWidget extends StatelessWidget {
  final Todo? todo;
  const TodoWidget({Key? key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var changeNotifier = Provider.of<TodoChangeNotifier>(context, listen: true);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TodoScreen(
                      todo: todo,
                    )));
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    todo?.title ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        var response = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDataScreen(
                              todo: todo,
                            ),
                          ),
                        );
                        if (response == true) {
                          await changeNotifier.getTaskList();
                        }
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Provider.of<TodoChangeNotifier>(context, listen: false)
                            .removeTodo(TodoModel(
                                id: todo!.id,
                                title: todo!.title,
                                description: todo!.description,
                                createdAtDate: todo!.createdAtDate));
                      })
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      todo?.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  todo?.createdAtDate ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
