import 'package:systeme_pers/classes/Employe.dart';

class Sanction {
  final int? id = null;
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
    _dateAnnulation ??= DateTime.now();
  }

  @override
  String toString() {
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    return 'Sanction: $_libelle\n' +
        'Motif: $_motif\n' +
        'Details: $_details\n' +
        'Date d\'application de la sanction: $_dateSanction\n' +
        'Employe ayant recu la sanction (Matricule): ${_employe!.matricule}\n' +
        'Duree de la sanction: $_dureeSanction\n' +
        (_dateAnnulation != null ? 'Date d\'annulation: $_dateAnnulation' : '');
  }
}
