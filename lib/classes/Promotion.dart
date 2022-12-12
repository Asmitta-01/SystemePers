import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/repositories/poste_repository.dart';

class Promotion {
  int? _id;
  Poste? _ancienPoste;
  Poste? _nouveauPoste;
  DateTime? _datePromotion;

  Employe? _employe;

  Promotion(
      {int? id,
      required Employe employe,
      required Poste ancienPoste,
      required Poste nouveauPoste,
      DateTime? datePromotion}) {
    // assert(employe.postes.contains(ancienPoste) || employe.postes.contains(nouveauPoste));
    // assert(employe.postes.any((element) => element.id == ancienPoste.id));

    _id = id;
    _employe = employe;
    _employe!.ajouterPromotion(this);
    // _employe!.contrats.firstWhere((element) => element.poste.id == ancienPoste.id).poste = nouveauPoste;

    _ancienPoste = ancienPoste;
    _nouveauPoste = nouveauPoste;

    _datePromotion = datePromotion ?? DateTime.now();
  }

  Employe get employe => _employe!;
  Poste get ancienPoste => _ancienPoste!;
  Poste get nouveauPoste => _nouveauPoste!;
  DateTime get datePromotion => _datePromotion!;

  @override
  String toString() {
    return '${_ancienPoste?.poste} --> ${_nouveauPoste?.poste}';
  }

  static Future<Promotion> fromJSON(Map<String, dynamic> json) async {
    var posteRepository = PosteRepository();
    var emplRepository = EmployeRepository();

    return Promotion(
      id: json['id_promo'],
      employe: await emplRepository.find(json['id_employe']),
      ancienPoste: (await posteRepository.findById(idPoste: json['id_ancien_poste']))!,
      nouveauPoste: (await posteRepository.findById(idPoste: json['id_nouv_poste']))!,
      datePromotion: DateTime.tryParse(json['date_promo']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'date_promo': _datePromotion!.toIso8601String(),
      'id_employe': _employe!.id,
      'id_ancien_poste': _ancienPoste!.id,
      'id_nouv_poste': _nouveauPoste!.id,
    };
  }
}
