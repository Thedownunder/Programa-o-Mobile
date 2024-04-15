import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  bool completed;

  Task(this.title, {this.completed = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(tasks[index].title),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
            },
            child: CheckboxListTile(
              title: Text(tasks[index].title),
              value: tasks[index].completed,
              onChanged: (newValue) {
                setState(() {
                  tasks[index].completed = newValue!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Task(_taskController.text),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
