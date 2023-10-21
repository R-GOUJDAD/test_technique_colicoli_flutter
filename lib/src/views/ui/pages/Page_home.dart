import 'package:flutter/material.dart';

import '../../../../routes/routesTask.dart';

class Page_home extends StatefulWidget {
  const Page_home({Key? key}) : super(key: key);

  @override
  State<Page_home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Page_home> {
  List<Map<String, dynamic>> tasks = []; // Liste des tâches

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
    });
  }

  // Méthode pour ajouter une tâche
  void addTask(String task) async {
    await RoutesTask.addTask(task);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
    });
  }

  // Méthode pour supprimer une tâche
  void deleteTask(String id) async {
    await RoutesTask.deleteTask(id);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
    });
  }

  // Méthode pour éditer une tâche
  void editTask(String id, String newTask) async {
    await RoutesTask.updateTask(id, newTask);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                // Afficher une boîte de dialogue pour ajouter une tâche
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]["Task"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Afficher une boîte de dialogue pour éditer la tâche
                          showDialog(
                            context: context,
                            builder: (context) {
                              String newTask = tasks[index]["Task"];
                              return AlertDialog(
                                title: const Text('Modifier la tâche'),
                                content: TextField(
                                  controller:
                                      TextEditingController(text: newTask),
                                  onChanged: (value) {
                                    newTask = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      editTask(tasks[index]["_id"], newTask);
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
                          deleteTask(tasks[index]["_id"]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
