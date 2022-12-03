import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Sanction.dart';
import 'package:http/http.dart' as http;

class SanctionRepository {
  Future<List<Future<Sanction>>?> findAllForEmploye(int idEmploye) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/sanction.php?id_empl=$idEmploye'));
    debugPrint('Fecthing Sanctions for Employe...');
    if (response.statusCode == 200) {
      var results = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      debugPrint('Fetching sanction for user $idEmploye');
      return results.map((c) => Sanction.fromJson(c)).toList();
    }

    return null;
  }

  Future<List<Future<Sanction>>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/sanction.php'));

    List<dynamic> results = jsonDecode(response.body);
    debugPrint('Fetching all Sanctions');
    return results.map((c) => Sanction.fromJson(c)).toList();
  }

  add({required Sanction sanction}) async {
    final response = await http.post(
      Uri.parse('http://localhost/syspers/sanction.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(sanction.toJson()),
    );
    debugPrint('Saving sanction...');
    if (response.statusCode == 201) {
      debugPrint('Saved');
    } else {
      debugPrint(response.body);
    }
  }
}
