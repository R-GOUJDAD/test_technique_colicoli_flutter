import 'package:flutter/material.dart';

class Page_home extends StatefulWidget {
  const Page_home({Key? key}) : super(key: key);

  @override
  State<Page_home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Page_home> {
  List<String> tasks = []; // Liste des tâches

  // Méthode pour ajouter une tâche
  void addTask(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  // Méthode pour supprimer une tâche
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Méthode pour éditer une tâche
  void editTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
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
                  title: Text(tasks[index]),
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
                              String newTask = tasks[index];
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
                                      editTask(index, newTask);
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
                          deleteTask(index);
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
