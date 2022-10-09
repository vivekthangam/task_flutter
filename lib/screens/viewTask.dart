import 'package:flutter/material.dart';
import 'package:flutter_application_learn/screens/addTask.dart';

import '../Widgets/text_manager.dart';
import '../styles/colors.dart';
import '../utils/SQLiteDbProvider.dart';
import 'allTask.dart';

class ViewTask extends StatelessWidget {
  const ViewTask(this.task, {Key? key}) : super(key: key);

  final Map<String, dynamic> task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View task"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Card(
              child: ListTile(
                title: Text(task["name"]),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTask(
                                  task: task,
                                )),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 17,
                          color: AppColors.myBlack,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Edit",
                          style:
                              textStyle(AppColors.myBlack, 17, FontWeight.w500),
                        ),
                      ],
                    )),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      SQLiteDbProvider.db.delete(task["id"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllTask()),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 17,
                          color: AppColors.myBlack,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Delete",
                          style:
                              textStyle(AppColors.myBlack, 17, FontWeight.w500),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
