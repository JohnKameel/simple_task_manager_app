import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_task_manager/core/db/db_sqflite.dart';
import 'package:simple_task_manager/core/db/shared_pref_helper.dart';

import '../../../../core/routing/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SqfLiteHelper database = SqfLiteHelper();
  final TextEditingController _addTaskController = TextEditingController();
  final TextEditingController _addDesController = TextEditingController();
  String username = '';
  List<Map<String, dynamic>> myTasks = [];

  @override
  void initState() {
    super.initState();
    // for take username from database
    loadUserName();
    // for take tasks from database
    getAllTasks();
  }

  // for view all tasks from database
  getAllTasks() async {
    final listOfTasks = await database.getAllTasks();

    setState(() {
      myTasks = listOfTasks;
    });
  }

  // for add new task and save it in database
  Future<void> addTask() async {
    await database.insertTask(_addTaskController.text, _addDesController.text);
    getAllTasks();
  }

  // for edit task and save it in database
  Future<void> editTask(int id, String title, String dec) async {
    await database.updateTask(id, title, dec);
    getAllTasks();
  }

  // for delete task from database
  Future<void> deleteTask(int id) async {
    await database.deleteTask(id);
    getAllTasks();
  }

  // for take username from database
  loadUserName() {
    String? usernameDB = SharedPrefHelper.getUserName();
    setState(() {
      username = usernameDB ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background color
      backgroundColor: Colors.white,
      // Name and Logout button
      appBar: AppBar(
        // background color
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            text: 'Hello ',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: username,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await SqfLiteHelper().deleteAllTasks();
              await SharedPrefHelper.clear();
              context.pushReplacement(RouterApp.login);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      // Add Task button
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // app body
      body: myTasks.isEmpty
          // if no tasks
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/Cat Movement.json',
                    width: 80,
                    height: 80,
                  ),
                  const Text(
                    'No Tasks ... Press + to add task',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          // if it have tasks
          : ListView.builder(
              shrinkWrap: true,
              itemCount: myTasks.length,
              itemBuilder: (context, index) {
                final task = myTasks[index];
                final completed = (myTasks[index]['isCompleted'] as int) == 1;
                return Slidable(
                  key: Key(task['id'].toString()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        spacing: 1,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: (_) async {
                          await deleteTask(task['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Task ${task['title']} deleted",
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: Card(
                    color: completed ? Colors.blueGrey : Colors.blue,
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Checkbox(
                          value: task['isCompleted'] == 1,
                          onChanged: (value) async {
                            // toggle task completion
                            await database.toggleTaskCompletion(
                              task['id'],
                              task['isCompleted'] as int,
                            );
                            await getAllTasks();
                          }),
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        task['dec'],
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                      // update task by long press
                      onLongPress: () {
                        _openUpdateTaskSheet(task);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // for make modalBottomSheet for add tasks
  Future<void> _openAddTaskSheet() async {
    _addTaskController.clear();
    _addDesController.clear();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            top: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add new Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _addTaskController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addDesController,
                decoration: const InputDecoration(
                  labelText: 'des',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    final title = _addTaskController.text.trim();
                    if (title.isEmpty) return;
                    await database.insertTask(
                      _addTaskController.text.trim(),
                      _addDesController.text.trim(),
                    );
                    await getAllTasks();
                    if (mounted) Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // for make modalBottomSheet for update tasks
  Future<void> _openUpdateTaskSheet(Map<String, dynamic> task) async {
    _addTaskController.text = task['title'] ?? '';
    _addDesController.text = task['dec'] ?? '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addTaskController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addDesController,
                decoration: const InputDecoration(
                  labelText: 'des',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  final title = _addTaskController.text.trim();
                  if (title.isEmpty) return;
                  await editTask(
                    task['id'] as int,
                    _addTaskController.text.trim(),
                    _addDesController.text.trim(),
                  );
                  await getAllTasks();
                  if (mounted) Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
