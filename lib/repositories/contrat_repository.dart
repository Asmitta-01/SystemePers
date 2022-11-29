import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Contrat.dart';
import 'package:http/http.dart' as http;

class ContratRepository {
  Future<List<Contrat>?> findAllForEmploye(int idEmploye) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/contrat.php?id_empl=$idEmploye'));
    debugPrint('Fecthing Contrats for Employe...');
    if (response.statusCode == 200) {
      var results = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return results.map((c) {
        Contrat ctr = Contrat();
        ctr.fromMap(c);
        return ctr;
      }).toList();
    }
    debugPrint('Done');

    return null;
  }

  Future<List<Contrat>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/contrat.php'));
    // if (response.statusCode == 200) {
    List<dynamic> results = jsonDecode(response.body);
    return results.map((c) {
      Contrat ctr = Contrat();
      ctr.fromMap(c);
      return ctr;
    }).toList();
    // }

    // return null;
  }
}
