import 'package:shared_preferences/shared_preferences.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

SharedPreferences? prefs;

class SessionManager {
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  nouvelleSessionUtilis(String matricule, String mdp, int id) async {
    await SessionManager.init();

    await prefs!.setString('matriculeUser', matricule);
    await prefs!.setString('mdpuser', mdp);
    await prefs!.setInt('idUser', id);
  }

  Future<Utilisateur?> getCurrentUser() async {
    prefs ??= await SessionManager.init();
    final String? matricule = prefs?.getString('matriculeUser');
    final String? mdp = prefs?.getString('mdpUser');
    final int? id = prefs?.getInt('idUser');

    if (matricule != null && mdp != null) {
      return Utilisateur(id: id, matricule: matricule, motdepasse: mdp);
    }
    return null;
  }

  Future<Employe?> getCurrentEmploye() async {
    var employeRepository = EmployeRepository();

    Utilisateur? user = await getCurrentUser();
    if (user != null && user.role != Role.admin) {
      return employeRepository.find(user.id!);
    } else {
      return null;
    }
  }
}
