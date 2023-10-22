import 'package:flutter/material.dart';

import '../../../../routes/routesTask.dart';

class Page_home extends StatefulWidget {
  const Page_home({Key? key}) : super(key: key);

  @override
  State<Page_home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Page_home> {
  List<Map<String, dynamic>> tasks = []; // Liste des tâches
  int taskCount = 0;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
      taskCount = tasks.length; // Mettez à jour le nombre de tâches
    });
  }

  // Méthode pour ajouter une tâche
  void addTask(String task) async {
    await RoutesTask.addTask(task);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  // Méthode pour supprimer une tâche
  void deleteTask(String id) async {
    await RoutesTask.deleteTask(id);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
      taskCount = tasks.length;
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

  void updateTaskStatus(String id, bool value) async {
    await RoutesTask.finTask(id, value);
    List<Map<String, dynamic>> fetchedTasks = await RoutesTask.fetchTasks();
    setState(() {
      // Mettez à jour votre état avec les données récupérées
      tasks = fetchedTasks;
      taskCount = tasks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 226, 226),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Hauteur préférée de l'AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(
                255, 175, 205, 232), // Couleur de fond de l'AppBar
            borderRadius: BorderRadius.circular(
                15.0), // Border radius pour les coins arrondis
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Ombre
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
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    // Case à cocher
                    value: tasks[index]
                        ["completed"], // Indiquez si la tâche est terminée
                    onChanged: (value) {
                      // Appeler une fonction pour mettre à jour l'état de la tâche
                      updateTaskStatus(tasks[index]["_id"], value!);
                    },
                  ),
                  title: Text(tasks[index]["Task"]), // Texte de la tâche
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
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
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
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
          ),
        ],
      ),
    );
  }
}
