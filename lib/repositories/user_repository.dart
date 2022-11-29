import 'dart:convert';
import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:systeme_pers/classes/Utilisateur.dart';

class UserRepository {
  /// Cree un nouvel utilisateur et renvoi son identifiant(id)
  Future<Utilisateur> createUser() async {
    var matricule = genererMatricule();
    while (getUser(matricule: matricule) != null) {
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

    print(response.body);
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

  setUserRole({required String matricule, required Role role}) async {
    await http.patch(Uri.parse('http://localhost/syspers/user.php'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'matricule': matricule,
          'role': role.index,
        }));

    debugPrint('Updated User role');
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
