import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';

// var listePromotions = [
//   Promotion(
//       employe: listEmployes!.first,
//       ancienPoste: listePostes.first,
//       nouveauPoste: listePostes.elementAt(2)),
//   Promotion(
//       employe: listEmployes!.elementAt(2),
//       ancienPoste: listePostes.last,
//       nouveauPoste: listePostes.first),
//   Promotion(
//       employe: listEmployes!.elementAt(5),
//       ancienPoste: listePostes.elementAt(4),
//       nouveauPoste: listePostes.elementAt(3))
// ];

class Promotion {
  final int _id = 0;
  Poste? _ancienPoste;
  Poste? _nouveauPoste;
  DateTime? _datePromotion;

  Employe? _employe;

  Promotion({required Employe employe, required Poste ancienPoste, required Poste nouveauPoste}) {
    assert(employe.postes.contains(ancienPoste));
    _employe = employe;
    _employe!.ajouterPromotion(this);
    _employe!.contrats.firstWhere((element) => element.poste == ancienPoste).poste = nouveauPoste;

    _ancienPoste = ancienPoste;
    _nouveauPoste = nouveauPoste;

    _datePromotion = DateTime.now();
  }

  Employe get employe => _employe!;
  Poste get ancienPoste => _ancienPoste!;
  Poste get nouveauPoste => _nouveauPoste!;
  DateTime get datePromotion => _datePromotion!;

  @override
  String toString() {
    return '${_ancienPoste?.poste} --> ${_nouveauPoste?.poste}';
  }
}
