import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Widgets/form_field.dart';
import '../Widgets/text_manager.dart';
import '../model/Task.dart';
import '../styles/colors.dart';
import '../utils/SQLiteDbProvider.dart';
import 'allTask.dart';

class AddTask extends StatefulWidget {
  const AddTask({this.task, Key? key}) : super(key: key);
  final Map<String, dynamic>? task;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var _tasknamecontroller = TextEditingController();

  var _tasknotescontroller = TextEditingController();

  var _tasktypecontroller = TextEditingController();
  bool _validateName = false;
  late String starttime;

  late DateTime selectedDate;
  bool isUpdate = false;

  // List of items in our dropdown menu
  var items = ['Todo', 'InProgress', 'Cancelled', 'Done'];
  late String dropdownvalue = items[0];
  MyColors? myColor = MyColors.red;
  TextEditingController startdateInput = TextEditingController();
  TextEditingController enddateInput = TextEditingController();
  bool isType = true,
      isNotes = true,
      isName = true,
      isStartTime = true,
      isEndTime = true;

  var _task_id;
  @override
  void initState() {
    if (widget.task != null) {
      isUpdate = true;
      _task_id = widget.task!["id"];
      _tasktypecontroller.text = widget.task!["type"];
      _tasknotescontroller.text = widget.task!["note"];
      _tasknamecontroller.text = widget.task!["name"];
      startdateInput.text = widget.task!["start_time"];
      enddateInput.text = widget.task!["end_time"];
      dropdownvalue = widget.task!["status"];
    } //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new task"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                  controller: _tasknamecontroller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Enter Task Title",
                      labelText: "Task Title",
                      errorText:
                          !isName ? "Task Title cannot be empty" : null)),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Notes',
                style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                  controller: _tasknotescontroller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Enter Notes",
                      labelText: "Notes",
                      errorText: !isNotes ? "Name cannot be empty" : null)),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Start Time',
                    style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
                  )),
                  Expanded(
                      child: Text(
                    'End Time',
                    style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
                  ))
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: startdateInput,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Start time"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          startdateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  )),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: TextField(
                    controller: enddateInput,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "End time"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          enddateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  )),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Type',
                style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                  controller: _tasktypecontroller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Enter Task Type",
                      labelText: "Task Type",
                      errorText: !isType ? "Task type cannot be empty" : null)),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Status',
                style: textStyle(AppColors.myBlack, 17, FontWeight.w500),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: DropdownButton(
                    value: dropdownvalue,
                    iconSize: 36,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    }),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (validate()) {
                      _task_id ??= Random().nextInt(10);
                      Task task = Task(
                          _task_id,
                          _tasknamecontroller.text,
                          _tasknotescontroller.text,
                          _tasktypecontroller.text,
                          dropdownvalue,
                          startdateInput.text,
                          enddateInput.text);
                      if (isUpdate) {
                        SQLiteDbProvider.db.update(task);
                      } else {
                        SQLiteDbProvider.db.insert(task);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllTask()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Alert Dialog Box"),
                          content:
                              const Text("You have raised a Alert Dialog Box"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(14),
                                child: const Text("okay"),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text("Add task"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool validate = true;

    if (_tasktypecontroller.value.text.isEmpty) {
      isType = false;
      validate = false;
    }
    if (_tasknotescontroller.value.text.isEmpty) {
      isNotes = false;
      validate = false;
    }
    if (_tasknamecontroller.value.text.isEmpty) {
      isName = false;
      validate = false;
    }
    if (startdateInput.value.text.isEmpty) {
      isStartTime = false;
      validate = false;
    }
    if (enddateInput.value.text.isEmpty) {
      isEndTime = false;
      validate = false;
    }
    return validate;
  }
}

enum MyColors { red, orange, yellow, green, blue, indigo, violet }
