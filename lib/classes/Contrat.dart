import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';

class Contrat {
  final int _id_contrat = 0;
  Duration? _duree_contrat;
  double? _salaire;
  DateTime? _date_signature;
  Duration? _duree_preavis;
  Duration? _duree_travail_hebdo;
  String? _clause_supplementaire;
  String? _statut;
  DateTime? _date_resiliation;
  DateTime? _date_modification;

  Poste? _poste;

  Employe? _employe;

  Contrat({Poste? poste}) {
    _poste = poste;
    _date_signature = DateTime.now();
    _statut = "Actif";
  }

  Duration get dureeContrat => _duree_contrat!;
  set dureeContrat(Duration d) {
    if (_duree_contrat == null) _date_modification = DateTime.now();
    _duree_contrat = d;
  }

  double get salaire => _salaire!;
  set salaire(double slr) {
    if (_salaire == null) _date_modification = DateTime.now();
    _salaire = slr;
  }

  Duration get dureePreavis => _duree_preavis!;
  set dureePreavis(Duration d) {
    if (_duree_preavis == null) _date_modification = DateTime.now();
    _duree_preavis = d;
  }

  Duration get nbrHeuresTravail => _duree_travail_hebdo!;
  set nbrHeuresTravail(Duration d) {
    if (_duree_travail_hebdo != null) _date_modification = DateTime.now();
    _duree_travail_hebdo = d;
  }

  String get clausesSupp => _clause_supplementaire!;
  set clausesSupp(String clauses) {
    if (_clause_supplementaire == null) _date_modification = DateTime.now();
    _clause_supplementaire = clauses;
  }

  Poste get poste => _poste!;
  set poste(Poste pst) {
    if (_poste == null) _date_modification = DateTime.now();
    _poste = pst;
  }

  Employe get employe => _employe!;
  set employe(Employe employe) {
    if (_employe == null) {
      employe.ajouterContrat(this);
      _employe = employe;
    }
  }

  bool get employeDefini => _employe != null;

  void resiliation() {
    _statut = 'Resilie';
    _date_resiliation = DateTime.now();
  }
}
