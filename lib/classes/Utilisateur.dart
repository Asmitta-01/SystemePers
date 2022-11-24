enum Role { admin, chargePersonnel, directeur, employe }

class Utilisateur {
  final int _id = 0;
  String _matricule = '';
  String _motdepasse = '';
  Role? _role;

  Utilisateur({String matricule = '', String motdepasse = ''}) {
    _matricule = matricule;
    _motdepasse = motdepasse;
  }

  String get matricule => _matricule;
  set matricule(value) => _matricule = value;

  String get motdepasse => _motdepasse;
  set motdepasse(value) => _motdepasse = value;

  Role get role => _role!;
  set role(Role rl) => _role = rl;
}
