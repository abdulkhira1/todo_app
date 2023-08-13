import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/component/custom_textfield.dart';
import 'package:todo_app/presentation/provider/todo_provider.dart';
import 'package:todo_app/presentation/utils/date_conveter.dart';
import 'package:uuid/uuid.dart';

class AddDataScreen extends StatefulWidget {
  final Todo? todo;
  const AddDataScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final FocusNode _titleNode = FocusNode();
  final FocusNode _contentNode = FocusNode();

  bool titleValid = false;
  var titleErrorMessage = '';

  DateTime? date;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateController.text = DateConverter.formatDate(DateTime.now());
    if (widget.todo != null) {
      titleController.text = widget.todo?.title ?? '';
      descriptionController.text = widget.todo?.description ?? '';
      dateController.text = widget.todo?.createdAtDate ??
          DateConverter.formatDate(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var changeNotifier = Provider.of<TodoChangeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            CustomTextField(
              label: "Title",
              controller: titleController,
              focusNode: _titleNode,
              nextFocus: _contentNode,
              inputType: TextInputType.text,
              maxLength: 50,
              validate: titleValid,
              errorLabel: titleErrorMessage,
              maxLines: 1,
            ),
            SizedBox(
              height: 15,
            ),
            CustomTextField(
              label: "Content",
              focusNode: _contentNode,
              controller: descriptionController,
              inputType: TextInputType.multiline,
            ),
            SizedBox(
              height: 15,
            ),
            CustomTextField(
              label: "Date",
              controller: dateController,
              readOnly: true,
              onTap: () => showDatePicker(),
              inputType: TextInputType.datetime,
            ),
            SizedBox(height: 10),
            Spacer(),
            TextButton(
              onPressed: () {
                addData(changeNotifier);
              },
              child: Container(
                color: Colors.blue,
                height: 50,
                child: Center(
                    child: Text(
                  widget.todo != null ? "Update" : "Add",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2030, 3, 5),
        onChanged: (_) {}, onConfirm: (selectedDate) {
      setState(() {
        if (widget.todo?.createdAtDate == null) {
          date = selectedDate;
        } else {
          widget.todo!.createdAtDate = DateConverter.formatDate(selectedDate);
        }
        dateController.text = DateConverter.formatDate(selectedDate);
      });
      FocusManager.instance.primaryFocus?.unfocus();
    }, currentTime: showDateAsDateTime(date));
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.todo?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return DateConverter.stringTodateTime(widget.todo!.createdAtDate ?? '');
    }
  }

  void addData(TodoChangeNotifier changeNotifier) async {
    var title = titleController.text.trim();
    titleValid = false;
    if (title.isEmpty) {
      setState(() {
        titleErrorMessage = 'Enter task title';
        titleValid = true;
      });
    } else {
      if (widget.todo != null) {
        widget.todo!.title = title;
        widget.todo!.description = descriptionController.text;
        widget.todo!.save();
      } else {
        TodoModel todo = TodoModel(
          id: Uuid().v1(),
          title: titleController.text,
          description: descriptionController.text,
          createdAtDate: dateController.text,
        );
        log(todo.toString());
        await changeNotifier.insertTodo(todo);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }
}
