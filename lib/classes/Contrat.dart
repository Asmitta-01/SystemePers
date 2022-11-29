import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/repositories/poste_repository.dart';

class Contrat {
  int? _id_contrat;
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

  Contrat({int? id, Poste? poste}) {
    _id_contrat = id;
    _poste = poste;
    _date_signature = DateTime.now();
    _statut = "Actif";
  }

  int? get id => _id_contrat;

  bool get estCDD => _duree_contrat != null;
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
  DateTime get dateSignature => _date_signature!;

  void resiliation() {
    _statut = 'Resilie';
    _date_resiliation = DateTime.now();
  }

  /// Tous les attributs sauf les deux derniers: Employe et Poste
  List<Object?> toArray() {
    return [
      _duree_contrat!.inDays,
      _salaire!,
      _date_signature!.toIso8601String(),
      _duree_preavis!.inDays.toString(),
      _duree_travail_hebdo!.inHours.toString(),
      _clause_supplementaire,
      _statut,
      _date_resiliation != null ? _date_resiliation!.toIso8601String() : null,
      _date_modification != null ? _date_modification!.toIso8601String() : null,
      _poste!.poste
    ];
  }

  fromMap(Map<String, dynamic> array) async {
    _duree_contrat = Duration(days: int.tryParse(array['duree_contrat'])!);
    _salaire = array['salaire'].toDouble();
    _date_signature = DateTime.tryParse(array['date_sign']);
    _duree_preavis = Duration(days: int.tryParse(array['periode_preavis'])!);
    _duree_travail_hebdo = Duration(hours: int.tryParse(array['duree_travail_hebdo'])!);
    _clause_supplementaire = array['clause_supp'];
    _statut = array['statut'];
    _date_resiliation =
        array['date_resilation'] == null ? null : DateTime.tryParse(array['date_resiliation']);
    _date_modification =
        array['date_modification'] == null ? null : DateTime.tryParse(array['date_modification']);

    var posteRepository = PosteRepository();
    _poste = await posteRepository.findById(idPoste: array['id_poste']);

    var employeRepository = EmployeRepository();
    _employe = await employeRepository.find(array['id_employe']);
  }
}
