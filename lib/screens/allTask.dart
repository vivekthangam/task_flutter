import 'package:flutter/material.dart';

import '../model/Task.dart';
import '../utils/SQLiteDbProvider.dart';
import 'addTask.dart';
import 'viewTask.dart';

class AllTask extends StatefulWidget {
  const AllTask({Key? key}) : super(key: key);

  @override
  _AllTaskState createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  List<String> items = ["All task", "Todo", "InProgress", "Cancelled", "Done"];
  final List<IconData> _icons = [
    Icons.home,
    Icons.explore,
    Icons.search,
    Icons.feed,
    Icons.post_add,
    Icons.local_activity,
    Icons.settings,
    Icons.person
  ];

  List<Task>? _tasks;

  List<Task>? _filteredtasks;
  int _currentBottomIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
        },
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: getBottomNavigationBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _current = index;
                            var _currenetstatus = items[index];
                            if (_currenetstatus == "All task") {
                              _filteredtasks = _tasks;
                            } else {
                              _filteredtasks = _tasks
                                  ?.where((element) =>
                                      element.status == _currenetstatus ||
                                      _currenetstatus == "All task")
                                  .toList();
                              print(_filteredtasks);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              margin: EdgeInsets.all(3),
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: _current == index
                                      ? Colors.lightBlue
                                      : Colors.white54,
                                  borderRadius: _current == index
                                      ? BorderRadius.circular(15)
                                      : BorderRadius.circular(10),
                                  border: _current == index
                                      ? Border.all(color: Colors.grey, width: 2)
                                      : null),
                              duration: Duration(milliseconds: 300),
                              child: Center(
                                child: Text(
                                  items[index],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: _current == index
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 30),
              //   width: double.infinity,
              //   height: 500,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         _icons[_current],
              //         size: 200,
              //         color: Colors.deepPurple,
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 500,
                child: FutureBuilder(
                  future: loadtask(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return ListView.builder(
                          itemCount: _filteredtasks?.length,
                          itemBuilder: (BuildContext context, int index) {
                            var _task = _filteredtasks![index].toMap();
                            return Container(
                              child: Column(
                                children: [
                                  myCard(_task),
                                ],
                              ),
                            );
                          });
                    } else {
                      return Text("No task");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> loadtask() async {
    SQLiteDbProvider.db.getAllTasks().then((continents) {
      setState(() {
        _tasks = continents;
        _filteredtasks = _tasks;
      });
    });

    if (_tasks != null) {
      return true;
    } else {
      return false;
    }
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentBottomIndex = index;
        });
      },
      currentIndex: _currentBottomIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.task), label: "home", backgroundColor: Colors.red),
        BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "task",
            backgroundColor: Colors.grey),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Me", backgroundColor: Colors.red)
      ],
      backgroundColor: Colors.white,
    );
  }

  Widget myCard(Map<String, dynamic> _task) {
    return GestureDetector(
      child: Column(
        children: [
          Card(
            color: Colors.grey[100],
            shadowColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.add)),
              title: Text(_task['name']),
              subtitle: Text(_task['note']),
              trailing: const Icon(Icons.train),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewTask(_task)),
        );
      },
    );
  }
}
