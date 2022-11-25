import 'package:systeme_pers/classes/Utilisateur.dart';

enum MessageType { notification, defaut, document }

var listeMessages = [
  Message(titre: 'Message 1', contenu: 'Beaucoup de choses'),
  Message(titre: 'Message 2', contenu: 'Autres choses'),
  Message(titre: 'Message 3', contenu: 'Certaines choses'),
  Message(titre: 'Message 4', contenu: 'Du n\'importe quoi'),
];

class Message {
  final int id = 0;
  MessageType? _type;
  String? _titre;
  String? _contenu;
  String? _pieceJointe;
  bool? _nonLu;

  bool? _visibleEmet;
  bool? _visibleRecept;

  DateTime? _dateEnvoi;
  DateTime? _dateLu;

  Utilisateur? _emetteur;
  Utilisateur? _recepteur;

  Message(
      {required String titre,
      String contenu = '',
      String pj = '',
      Utilisateur? from,
      Utilisateur? to}) {
    _titre = titre;
    _contenu = contenu;
    _pieceJointe = pj;
    assert(_contenu != '' || _pieceJointe != '');

    _emetteur = from;
    _recepteur = to;

    _nonLu = true;
    _visibleEmet = _visibleRecept = true;
    _dateEnvoi = DateTime.now();
    _setType();
  }

  String get titre => _titre!;
  DateTime get dateEnvoi => _dateEnvoi!;

  set emetteur(Utilisateur emt) => _emetteur = emt;
  Utilisateur get emetteur => _emetteur!;

  set recepteur(Utilisateur rcp) => _recepteur = rcp;
  Utilisateur get recepteur => _recepteur!;

  marqueCommeLu() {
    _nonLu = false;
    _dateLu = DateTime.now();
  }

  envoyer({required Utilisateur from, required Utilisateur to}) {
    _emetteur = from;
    _recepteur = to;
    _dateEnvoi = DateTime.now();
  }

  supprimerCoteEmetteur() => _visibleEmet = false;
  supprimerCoteRecepteur() => _visibleRecept = false;

  _setType() {
    _type = _contenu!.isNotEmpty && _pieceJointe!.isNotEmpty
        ? MessageType.defaut
        : _contenu!.isNotEmpty
            ? MessageType.document
            : MessageType.notification;
  }
}
