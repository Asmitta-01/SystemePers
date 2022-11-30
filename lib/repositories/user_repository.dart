import 'dart:convert';
import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:systeme_pers/classes/Utilisateur.dart';

class UserRepository {
  Future<Utilisateur> createUser() async {
    var matricule = genererMatricule();
    while (getUser(matricule: matricule) == null) {
      matricule = genererMatricule();
    }

    var motdepasse = genererMotDePasse();
    final response = await http.post(
      Uri.parse('http://localhost/syspers/user.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'matricule': matricule,
        'motdepasse': motdepasse,
      }),
    );

    debugPrint(response.body);
    return Utilisateur(
      id: int.tryParse(response.body),
      matricule: matricule,
      motdepasse: motdepasse,
    );
  }

  Future<Utilisateur?> getUser({required String matricule}) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/user.php?matricule=$matricule'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecode2 = jsonDecode(response.body);
      debugPrint('Done');
      return Utilisateur(
          id: jsonDecode2['id'],
          matricule: jsonDecode2['matricule'],
          motdepasse: jsonDecode2['motdepasse'],
          role: Role.values.elementAt(jsonDecode2['role']));
    } else {
      return null;
    }
  }

  Future<Utilisateur?> getUserById({required int id}) async {
    final response = await http.get(Uri.parse('http://localhost/syspers/user.php?id=$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecode2 = jsonDecode(response.body);
      debugPrint('Done');
      return Utilisateur(
          id: jsonDecode2['id'],
          matricule: jsonDecode2['matricule'],
          motdepasse: jsonDecode2['motdepasse'],
          role: Role.values.elementAt(jsonDecode2['role']));
    } else {
      return null;
    }
  }

  Future<List<Utilisateur>> all({bool withAdmin = false}) async {
    final response = await http.get(Uri.parse('http://localhost/syspers/user.php'));

    List<dynamic> json = jsonDecode(response.body);
    debugPrint('Fetched all users');
    if (withAdmin == false) {
      json = json.where((element) => Role.values.elementAt(element['role']) != Role.admin).toList();
    }

    return json
        .map((element) => Utilisateur(
            id: element['id'],
            matricule: element['matricule'],
            motdepasse: element['motdepasse'],
            role: Role.values.elementAt(element['role'])))
        .toList();
  }

  setUserRole({required String matricule, required Role role}) async {
    await http.patch(Uri.parse('http://localhost/syspers/user.php'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'matricule': matricule,
          'role': role.index,
        }));

    debugPrint('Updated User role');
  }

  delete({required String matricule}) async {
    await http.delete(Uri.parse('http://localhost/syspers/user.php'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'matricule': matricule,
        }));

    debugPrint('Deleted User $matricule');
  }

  String genererMotDePasse() {
    var r = Random();
    return String.fromCharCodes(List.generate(6, (index) => r.nextInt(33) + 89));
  }

  String genererMatricule([int longueur = 6]) {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(longueur, (index) => chars[r.nextInt(chars.length)]).join();
  }
}
