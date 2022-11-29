import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Contrat.dart';
import 'package:http/http.dart' as http;

class ContratRepository {
  Future<List<Future<Contrat>>?> findAllForEmploye(int idEmploye) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/contrat.php?id_empl=$idEmploye'));
    debugPrint('Fecthing Contrats for Employe...');
    if (response.statusCode == 200) {
      var results = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      debugPrint('Fetching contrat for user $idEmploye');
      return results.map((c) async {
        Contrat ctr = Contrat();
        await ctr.fromMap(c);
        return ctr;
      }).toList();
    }

    return null;
  }

  Future<List<Future<Contrat>>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/contrat.php'));
    // if (response.statusCode == 200) {
    List<dynamic> results = jsonDecode(response.body);
    debugPrint('Fetching all Contrats');
    return results.map((c) async {
      Contrat ctr = Contrat();
      await ctr.fromMap(c);
      return ctr;
    }).toList();
    // }

    // return null;
  }
}
