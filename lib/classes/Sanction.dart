import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

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
      int? dureeSanction,
      String? dateSanction,
      String? dateSAnnulation}) {
    _libelle = libelle;
    _motif = motif;
    _details = details;

    _employe = employe;
    employe.ajouterSanction(this);

    _dateSanction = DateTime.now();

    _active = false;
    if ((_dateAnnulation != null && _dateAnnulation!.compareTo(DateTime.now()) < 0) ||
        (_dureeSanction != null &&
            _dateSanction!.add(_dureeSanction!).compareTo(DateTime.now()) > 0)) _active = true;
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

  Map<String, dynamic> toJson() {
    return {
      'libelle': _libelle,
      'motif': _motif,
      'details': _details,
      'date_sanction': _dateSanction?.toIso8601String(),
      'duree_sanction': _dureeSanction?.inDays,
      'date_annulation': _dateAnnulation?.toIso8601String(),
      'active': _active,
      'id_employe': _employe?.id
    };
  }

  static Future<Sanction> fromJson(Map<String, dynamic> json) async {
    var employeRepository = EmployeRepository();
    return Sanction(
      libelle: json['libelle'],
      motif: json['motif'],
      employe: await employeRepository.find(json['id_employe']),
      details: json['details'],
      dureeSanction: json['duree_sanction'],
      dateSAnnulation: json['date_annulation'],
      dateSanction: json['date_sanction'],
    );
  }
}
