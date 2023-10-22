import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutesTask {
  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/GetAllTasks'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> taskList =
          List.from(json.decode(response.body));
      return taskList;
    } else {
      throw Exception('Échec de la récupération des tâches');
    }
  }

  static Future<void> addTask(String newTask) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/AddTask/$newTask'),
    );
    if (response.statusCode == 200) {
      // La tâche a été ajoutée avec succès
    } else {
      throw Exception('Échec de l\'ajout de la tâche');
    }
  }

  static Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/deletTask/$id'),
    );
    if (response.statusCode == 200) {
      print("la tache a ete suppreme avec ceces");
    } else {
      throw Exception('Échec de la suppression de la tâche');
    }
  }

  static Future<void> updateTask(String id, String newTask) async {
    final response = await http.patch(
      Uri.parse('http://localhost:3000/updateTask/$newTask/$id'),
    );
    if (response.statusCode == 200) {
      // La tâche a été mise à jour avec succès
    } else {
      throw Exception('Échec de la mise à jour de la tâche');
    }
  }
    static Future<void> finTask(String id, bool value) async {
    final response = await http.patch(
      Uri.parse('http://localhost:3000/finTask/$value/$id'),
    );
    if (response.statusCode == 200) {
      // La tâche a été mise à jour avec succès
    } else {
      throw Exception('Échec de la mise à jour de la tâche');
    }
  }
}
