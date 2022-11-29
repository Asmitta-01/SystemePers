import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/classes/Message.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/classes/Promotion.dart';
import 'package:systeme_pers/classes/Sanction.dart';

import 'package:systeme_pers/classes/Utilisateur.dart';

class Employe extends Utilisateur {
  String _nom = '';
  String? _prenom;
  String _numeroCni = '';
  DateTime? _dateNaissance;

  final List<Contrat> _contrats = <Contrat>[];
  final List<Promotion> _promotions = <Promotion>[];
  final List<Sanction> _sanctions = <Sanction>[];
  final List<Message> _messages = <Message>[];

  Employe(
      {super.id,
      super.matricule,
      super.motdepasse,
      required String nom,
      prenom = '',
      numeroCni = '',
      String dateNaissance = '2001-07-08',
      Contrat? contrat,
      List<Contrat>? contrats}) {
    _nom = nom;
    _prenom = prenom;
    _numeroCni = numeroCni;
    _dateNaissance = DateTime.parse(dateNaissance);

    if (contrat != null) _contrats.add(contrat);
    if (contrats != null) for (var element in _contrats) ajouterContrat(element);

    super.role = Role.employe;
  }

  String get nom => _nom;
  set nom(String value) => _nom = value.toUpperCase();

  String? get prenom => _prenom;
  set prenom(String? value) => _prenom = value!;

  String? get numeroCni => _numeroCni;
  set numeroCni(String? value) => _numeroCni = value!;

  set dateNaissance(DateTime date) => _dateNaissance = date;
  DateTime get dateNaissance => _dateNaissance!;

  List<Contrat> get contrats => _contrats;
  List<Promotion> get promotions => _promotions;
  List<Sanction> get sanction => _sanctions;
  List<Poste> get postes => _contrats.map((e) => e.poste).toList();

  void ajouterContrat(Contrat ctr) {
    // if (!ctr.employeDefini || (ctr.employeDefini && ctr.employe != this)) ctr.employe = this;
    if (_contrats.any((element) => element == Contrat())) _contrats.remove(Contrat());
    _contrats.add(ctr);
  }

  void ajouterPromotion(Promotion prom) {
    _promotions.add(prom);
  }

  void ajouterSanction(Sanction sanction) {
    if (sanction.employe != this) sanction.employe = this;
    _sanctions.add(sanction);
  }

  void ajouterMessage(Message msg) {
    _messages.add(msg);
  }

  void supprimerContrat(Contrat ctr) {
    if (_contrats.length == 1) {
      // Renvoi definitif
    }
    _contrats.remove(ctr);
  }

  List<Object> toArray() {
    return [
      _nom,
      _prenom!,
      _numeroCni,
      _dateNaissance!.toIso8601String(),
    ];
  }
}
