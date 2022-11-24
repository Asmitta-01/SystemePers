import 'package:systeme_pers/classes/Employe.dart';

var listeSanctions = [
  Sanction(
      libelle: 'Suppression des conges',
      motif: 'Retards abusifs',
      employe: listEmployes.first),
  Sanction(
      libelle: 'Deduction de 50% du salaire',
      motif: 'Dommage et interets',
      employe: listEmployes.first),
  Sanction(
      libelle: 'Deduction de 10% du salaire',
      motif: 'Retards abusifs',
      employe: listEmployes.last),
  Sanction(
      libelle: 'Heures supplementaires non remunerees',
      motif: 'Retards abusifs',
      employe: listEmployes.elementAt(4)),
  Sanction(
      libelle: 'Renvoi temporaire',
      motif: 'Manque de respect',
      employe: listEmployes.elementAt(7)),
];

class Sanction {
  final int id = 0;
  String? _libelle;
  String? _motif;
  String? _details;
  DateTime? _dateSanction;
  Duration? _dureeSanction;
  DateTime? _dateAnnulation;
  bool? _active;

  Employe? _employe;

  Sanction(
      {required String libelle,
      required String motif,
      required Employe employe,
      details = '',
      String dureeSanction = ''}) {
    _libelle = libelle;
    _motif = motif;
    _details = details;

    _employe = employe;
    employe.ajouterSanction(this);

    _dateSanction = DateTime.now();
    _active = true;
  }

  set libelle(String libl) => _libelle = libl;
  String get libelle => _libelle!;

  set motif(String motif) => _motif = motif;
  String get motif => _motif!;

  set details(String det) => _details = det;
  String get details => _details!;

  DateTime get dateDeclaration => _dateSanction!;

  DateTime? get dateAnnulation => _dateAnnulation;

  bool get estActive => _active!;

  set employe(Employe employe) => _employe = employe;
  Employe get employe => _employe!;

  void annuler() {
    _active = false;
    _dateAnnulation = DateTime.now();
  }
}
