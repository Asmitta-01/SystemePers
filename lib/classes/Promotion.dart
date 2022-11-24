import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';

var listePromotions = [
  Promotion(
      employe: listEmployes.first, ancienPoste: listePostes.last, nouveauPoste: listePostes.first),
  Promotion(
      employe: listEmployes.elementAt(4),
      ancienPoste: listePostes.elementAt(2),
      nouveauPoste: listePostes.elementAt(3))
];

class Promotion {
  final int _id = 0;
  Poste? _ancienPoste;
  Poste? _nouveauPoste;
  DateTime? _datePromotion;

  Employe? _employe;

  Promotion({required Employe employe, required Poste ancienPoste, required Poste nouveauPoste}) {
    _employe = employe;
    employe.ajouterPromotion(this);

    _ancienPoste = ancienPoste;
    _nouveauPoste = nouveauPoste;
    _datePromotion = DateTime.now();
  }

  Poste get ancienPoste => _ancienPoste!;

  Poste get nouveauPoste => _nouveauPoste!;

  DateTime get datePromotion => _datePromotion!;

  @override
  String toString() {
    return '${_ancienPoste?.poste} --> ${_nouveauPoste?.poste}';
  }
}
