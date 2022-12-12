import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/repositories/poste_repository.dart';

class Contrat {
  int? _id_contrat;

  /// Duree du contrat en jours
  int? _duree_contrat;
  double? _salaire;
  DateTime? _date_signature;

  /// Nombre jours de preavis
  int? _duree_preavis;

  /// Nombre d'heures de travail par semaine
  int? _duree_travail_hebdo;
  String? _clause_supplementaire;
  String? _statut;
  DateTime? _date_resiliation;
  DateTime? _date_modification;

  Poste? _poste;
  Employe? _employe;

  Contrat(
      {int? id,
      int? dureeContrat,
      double? salaire,
      int? dureePreavis,
      int? dureeHebdo,
      DateTime? dateSignature,
      String? clauseSupp,
      String? statut,
      DateTime? dateResiliation,
      DateTime? dateModification,
      Poste? poste,
      Employe? empl}) {
    _id_contrat = id;
    _duree_contrat = dureeContrat;
    _salaire = salaire;
    _duree_preavis = dureePreavis;
    _duree_travail_hebdo = dureeHebdo;
    _clause_supplementaire = clauseSupp;
    _date_modification = dateModification;
    _date_resiliation = dateResiliation;
    _poste = poste;
    _date_signature = dateSignature ?? DateTime.now();
    _statut = statut ?? "Actif";
    if (empl != null) employe = empl;
  }

  int? get id => _id_contrat;

  bool get estCDD => _duree_contrat != null;
  int get dureeContrat => _duree_contrat!;
  set dureeContrat(int d) {
    if (_duree_contrat == null) _date_modification = DateTime.now();
    _duree_contrat = d;
  }

  double get salaire => _salaire!;
  set salaire(double slr) {
    if (_salaire == null) _date_modification = DateTime.now();
    _salaire = slr;
  }

  int get dureePreavis => _duree_preavis!;
  set dureePreavis(int d) {
    if (_duree_preavis == null) _date_modification = DateTime.now();
    _duree_preavis = d;
  }

  int get nbrHeuresTravail => _duree_travail_hebdo!;
  set nbrHeuresTravail(int d) {
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
  DateTime get dateSignature => _date_signature!;

  void resiliation() {
    _statut = 'Resilie';
    _date_resiliation = DateTime.now();
  }

  /// Tous les attributs sauf les deux derniers: Employe et Poste
  Map<String, dynamic> toJSON() {
    return {
      'salaire': _salaire!,
      'duree_contrat': _duree_contrat,
      'date_signature': _date_signature!.toIso8601String(),
      'duree_preavis': _duree_preavis!,
      'duree_hebdo': _duree_travail_hebdo!,
      'clause_supp': _clause_supplementaire,
      'statut': _statut,
      'date_resiliation': _date_resiliation != null ? _date_resiliation!.toIso8601String() : null,
      'date_modification':
          _date_modification != null ? _date_modification!.toIso8601String() : null,
      'id_poste': _poste!.id,
      'id_employe': _employe!.id
    };
  }

  static Future<Contrat> fromJSON(Map<String, dynamic> array) async {
    var posteRepository = PosteRepository();
    var employeRepository = EmployeRepository();

    return Contrat(
      id: array['id_contrat'],
      dureeContrat: array['duree_contrat'],
      salaire: array['salaire'].toDouble(),
      dateSignature: DateTime.tryParse(array['date_sign']),
      dureePreavis: array['periode_preavis'],
      dureeHebdo: array['duree_travail_hebdo'],
      clauseSupp: array['clause_supp'],
      statut: array['statut'],
      dateModification:
          array['date_modification'] != null ? DateTime.tryParse(array['date_modification']) : null,
      dateResiliation:
          array['date_resiliation'] != null ? DateTime.tryParse(array['date_resiliation']) : null,
      poste: await posteRepository.findById(idPoste: array['id_poste']),
      empl: await employeRepository.find(array['id_employe']),
    );
  }
}
