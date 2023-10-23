import 'package:flutter/material.dart';

import '../../../../routes/routesTask.dart';
import 'package:intl/intl.dart'; // pour la forma Date

class Page_home extends StatefulWidget {
  const Page_home({Key? key}) : super(key: key);

  @override
  State<Page_home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Page_home> {
  List<Map<String, dynamic>> tasks = [];
  int taskCount = 0;
  final searchController = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  void getAllTask() async {
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  void addTask(String task) async {
    await RoutesTask.addTask(task);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  void deleteTask(String id) async {
    await RoutesTask.deleteTask(id);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  void editTask(String id, String newTask) async {
    await RoutesTask.updateTask(id, newTask);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  void updateTaskStatus(String id, bool value) async {
    await RoutesTask.finTask(id, value);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  void updateTaskList(String searchText) {
    setState(() {
      tasks = tasks.where((task) {
        final taskName = task["Task"].toString().toLowerCase();
        return taskName.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  String getFormattedDate(DateTime date) {
    // Ici, nous utilisons le format par défaut "dd/MM/yyyy", mais vous pouvez le personnaliser.
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 226, 226),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 175, 205, 232),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Toutes les tâches"),
                Text(
                  "$taskCount tâches",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher des tâches...',
                    ),
                    onChanged: (text) {
                      if (text == "") {
                        getAllTask();
                      }
                      updateTaskList(text);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    updateTaskList('');
                    getAllTask();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                //=============================================================================
                final taskDate = DateTime.parse(task[
                    "date"]); // Supposons que la date est stockée sous forme de String
                final formattedDate = getFormattedDate(taskDate);

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: task["completed"],
                          onChanged: (value) {
                            updateTaskStatus(task["_id"], value!);
                          },
                        ),
                        title: Text(task["Task"]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String newTask = task["Task"];
                                    return AlertDialog(
                                      title: const Text('Modifier la tâche'),
                                      content: TextField(
                                        controller: TextEditingController(
                                            text: newTask),
                                        onChanged: (value) {
                                          newTask = value;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            editTask(task["_id"], newTask);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Enregistrer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteTask(task["_id"]);
                              },
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            7), // Modifiez la valeur de borderRadius selon vos préférences
                        child: Container(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              formattedDate, // Affichez la date formatée
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTask = '';
              return AlertDialog(
                title: const Text('Ajouter une tâche'),
                content: TextField(
                  onChanged: (value) {
                    newTask = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addTask(newTask);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
