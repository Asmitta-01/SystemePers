import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/classes/Message.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/classes/Promotion.dart';
import 'package:systeme_pers/classes/Sanction.dart';

import 'package:systeme_pers/classes/Utilisateur.dart';

var listEmployes = [
  Employe(
      matricule: '10DDN1',
      nom: 'User 1',
      prenom: 'First User',
      contrat: Contrat(poste: listePostes.first)),
  Employe(matricule: '11FDN1', nom: 'User 2', prenom: 'Second User', contrat: Contrat()),
  Employe(
      matricule: '10D231',
      nom: 'User 3',
      prenom: 'Third User',
      contrat: Contrat(poste: listePostes.first)),
  Employe(
      matricule: '10D221',
      nom: 'User 4',
      prenom: 'Fourth User',
      contrat: Contrat(poste: listePostes.last)),
  Employe(matricule: '10D211', nom: 'User 5', prenom: 'Fifth User', contrat: Contrat()),
  Employe(
      matricule: '10FF51',
      nom: 'User 6',
      prenom: 'Sixth User',
      contrat: Contrat(poste: listePostes.elementAt(2))),
  Employe(matricule: '19D231', nom: 'User 7', prenom: 'Seventh User', contrat: Contrat()),
  Employe(
      matricule: '30D231',
      nom: 'User 8',
      prenom: '... User',
      contrat: Contrat(poste: listePostes.elementAt(4))),
  Employe(matricule: '1JJ231', nom: 'User 10', prenom: '... User', contrat: Contrat()),
  Employe(matricule: '10E983', nom: 'User 11', prenom: '... User', contrat: Contrat()),
];

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
      {super.matricule,
      super.motdepasse,
      required String nom,
      prenom = '',
      numeroCni = '',
      dateNaissance,
      required Contrat contrat}) {
    _nom = nom;
    _prenom = prenom;
    _numeroCni = numeroCni;

    _contrats.add(contrat);

    super.role = Role.employe;
  }

  String get nom => _nom;
  set nom(String value) => _nom = value.toUpperCase();

  String? get prenom => _prenom;
  set prenom(String? value) => _prenom = value!;

  set dateNaissance(DateTime date) => _dateNaissance = date;

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
    _contrats.remove(ctr);
  }
}
