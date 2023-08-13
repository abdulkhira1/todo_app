import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/presentation/component/custom_textfield.dart';
import 'package:todo_app/presentation/component/todo_widget.dart';
import 'package:todo_app/presentation/provider/todo_provider.dart';
import 'package:todo_app/presentation/screen/add_data_screen.dart';
import 'package:todo_app/presentation/utils/date_conveter.dart';

const String progressIndicatorKey = "PROGRESS INDICATOR KEY";

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    Provider.of<TodoChangeNotifier>(context, listen: false).getTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var changeNotifier = Provider.of<TodoChangeNotifier>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          var response = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDataScreen(),
            ),
          );
          if (response == true) {
            await changeNotifier.getTaskList();
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchTextField(
              controller: controller,
              hint: "Search task...",
              onChanged: (value) {
                if (value.isNotEmpty) {
                  changeNotifier.getTaskList(filter: value);
                } else {
                  changeNotifier.getTaskList();
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<TodoChangeNotifier>(
                builder: (context, notifier2, child) {
                  if (changeNotifier.taskList.isEmpty) {
                    return Center(
                      child: Text("No data"),
                    );
                  } else {
                    return StickyGroupedListView<Todo, String>(
                      elements: changeNotifier.taskList,
                      order: StickyGroupedListOrder.DESC,
                      groupBy: (Todo element) => DateConverter.checkDateGroup(
                          element.createdAtDate ?? ''),
                      groupComparator: (String value1, String value2) =>
                          value2.compareTo(value1),
                      itemComparator: (Todo element1, Todo element2) =>
                          DateConverter.checkDateGroup(
                                  element1.createdAtDate ?? '')
                              .compareTo(DateConverter.checkDateGroup(
                                  element2.createdAtDate ?? '')),
                      floatingHeader: true,
                      groupSeparatorBuilder: _getGroupSeparator,
                      itemBuilder: (BuildContext context, todo) {
                        return TodoWidget(
                          todo: todo,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getGroupSeparator(Todo element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateConverter.checkDateGroup(element.createdAtDate ?? ''),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
