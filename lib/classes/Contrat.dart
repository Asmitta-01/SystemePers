import 'package:flutter/material.dart';
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

  double get salaire => _salaire!;
  set salaire(double slr) => _salaire = slr;

  Poste get poste => _poste!;
  set poste(Poste pst) => _poste = pst;

  Employe get employe => _employe!;
  set employe(Employe employe) {
    employe.ajouterContrat(this);
    _employe = employe;
  }

  void resiliation() {
    _statut = 'Resilie';
    _date_resiliation = DateTime.now();
  }
}
