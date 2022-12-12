import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/contrat_repository.dart';
import 'package:systeme_pers/repositories/user_repository.dart';

class EmployeRepository {
  Future<Utilisateur> add({required Employe employe, required Contrat contrat}) async {
    var userRepository = UserRepository();
    var user = await userRepository.createUser();
    userRepository.setUserRole(matricule: user.matricule, role: Role.employe);
    user.role = Role.employe;
    employe.recevoirDonneesUser(user);

    final response = http.post(
      Uri.parse('http://localhost/syspers/employe.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(employe.toJSON()),
    );

    contrat.employe = employe;
    var contratRepository = ContratRepository();
    contratRepository.add(contrat: contrat);

    return user;
  }

  bool update({required Employe employe}) {
    http
        .put(
      Uri.parse('http://localhost/syspers/employe.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(employe.toJSON()),
    )
        .then((response) {
      if (response.statusCode == 202) {
        return true;
      } else {
        debugPrint(response.body);
      }
    });

    return false;
  }

  Future<List<Employe>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/employe.php'));
    List<dynamic> results = jsonDecode(response.body);

    debugPrint('Fetched all employees...');

    return results
        .map((e) => Employe(
              id: e['id_user'],
              nom: e['nom_empl'],
              prenom: e['prn_empl'],
              numeroCni: e['numero_cni'],
              dateNaissance: e['date_naissance'],
            ))
        .toList();
  }

  Future<Employe> find(int idEmploye) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/employe.php?user_id=$idEmploye'));
    // if (response.statusCode == 200) {
    var userRepository = UserRepository();
    var e = jsonDecode(response.body);
    Utilisateur? user = await userRepository.getUserById(id: e['id_user']);

    return Employe(
      id: e['id_user'],
      matricule: user!.matricule,
      motdepasse: user.motdepasse,
      nom: e['nom_empl'],
      prenom: e['prn_empl'],
      numeroCni: e['numero_cni'],
      dateNaissance: e['date_naissance'],
    );
    // }
  }

  Future<Employe?> findByMatricule(String matr) async {
    var userRepository = UserRepository();
    Utilisateur? user = await userRepository.getUser(matricule: matr);

    return find(user!.id!);
  }
}
