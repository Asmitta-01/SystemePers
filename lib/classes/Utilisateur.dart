import 'package:fluent_ui/fluent_ui.dart';

enum Role { admin, chargePersonnel, directeur, employe }

class Utilisateur {
  int? _id = null;
  String _matricule = '';
  String _motdepasse = '';
  Role? _role;

  Utilisateur({int? id, String matricule = '', String motdepasse = '', Role role = Role.admin}) {
    _id = id;
    _matricule = matricule;
    _motdepasse = motdepasse;
    _role = role;
  }

  @protected
  set id(int? value) => _id = value;
  int? get id => _id;

  String get matricule => _matricule;
  set matricule(value) => _matricule = value;

  String get motdepasse => _motdepasse;
  set motdepasse(value) => _motdepasse = value;

  Role get role => _role!;
  set role(Role rl) => _role = rl;
}
