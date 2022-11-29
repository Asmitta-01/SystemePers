import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:systeme_pers/classes/Poste.dart';

class PosteRepository {
  Future<Poste?> findByName({required String nomPoste}) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/poste.php?nom_poste=$nomPoste'));
    debugPrint('Fecthing data : Poste...');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecode2 = jsonDecode(response.body);
      debugPrint('Done');
      return Poste(
          id: jsonDecode2['id_poste'],
          nomDuPoste: jsonDecode2['designation_poste'],
          description: jsonDecode2['description']);
    } else {
      return null;
    }
  }

  Future<Poste?> findById({required int idPoste}) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/poste.php?id_poste=$idPoste'));
    debugPrint('Fecthing data : Poste...');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecode2 = Map<String, dynamic>.from(jsonDecode(response.body));
      debugPrint('Done');
      return Poste(
          id: jsonDecode2['id_poste'],
          nomDuPoste: jsonDecode2['designation_poste'],
          description: jsonDecode2['description']);
    } else {
      return null;
    }
  }

  Future<List<Poste>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/poste.php'));
    debugPrint('Fecthing data : All Postes...');
    // if (response.statusCode == 200) {
    List<dynamic> jsonDecode2 = jsonDecode(response.body);
    debugPrint('Done');
    return jsonDecode2
        .map((poste) => Poste(
            id: poste['id_poste'],
            nomDuPoste: poste['designation_poste'],
            description: poste['description']))
        .toList();
    // } else {
    //   return null;
    // }
  }
}
