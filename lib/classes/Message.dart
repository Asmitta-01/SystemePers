import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/user_repository.dart';

enum MessageType { notification, defaut, document }

var listeMessages = [
  Message(titre: 'Message 1', contenu: 'Beaucoup de choses'),
  Message(titre: 'Message 2', contenu: 'Autres choses'),
  Message(titre: 'Message 3', contenu: 'Certaines choses'),
  Message(titre: 'Message 4', contenu: 'Du n\'importe quoi'),
];

class Message {
  final int? id = null;
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

  Message({
    required String titre,
    String contenu = '',
    String pj = '',
    Utilisateur? from,
    Utilisateur? to,
    bool nonLu = true,
    bool visEmet = true,
    bool visRecp = true,
    DateTime? dateEnvoi,
    DateTime? dateLu,
  }) {
    _titre = titre;
    _contenu = contenu;
    _pieceJointe = pj;
    assert(_contenu != '' || _pieceJointe != '');

    _emetteur = from;
    _recepteur = to;

    _nonLu = true;
    _visibleEmet = visEmet;
    _visibleRecept = visRecp;
    _dateEnvoi = dateEnvoi ?? DateTime.now();
    _dateLu = dateLu;
    _setType();
  }

  String get titre => _titre!;
  DateTime get dateEnvoi => _dateEnvoi!;

  set emetteur(Utilisateur emt) => _emetteur = emt;
  Utilisateur get emetteur => _emetteur!;

  set recepteur(Utilisateur rcp) => _recepteur = rcp;
  Utilisateur get recepteur => _recepteur!;

  bool get estNonLu => _nonLu!;

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

  static Future<Message> fromJSON(Map<String, dynamic> json) async {
    var userRepository = UserRepository();
    var userEm = await userRepository.getUserById(id: json['id_emetteur']);
    var userRc = await userRepository.getUserById(id: json['id_recepteur']);

    return Message(
      titre: json['titre'],
      contenu: json['contenu'],
      from: userEm,
      to: userRc,
      pj: json['piece_jointe'],
      nonLu: json['non_lu'] == 1 ? true : false,
      dateEnvoi: DateTime.tryParse(json['date_envoi']),
      dateLu: json['date_lu'] != null ? DateTime.tryParse(json['date_lu']) : null,
      visEmet: json['visble_emetteur'] == 1 ? true : false,
      visRecp: json['visble_recepteur'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': _type?.index,
      'titre': _titre,
      'contenu': _contenu,
      'piece_jointe': _pieceJointe,
      'non_lu': _nonLu,
      'visible_emetteur': _visibleEmet,
      'visible_recepteur': _visibleRecept,
      'date_envoi': _dateEnvoi?.toIso8601String(),
      'date_lu': _dateLu?.toIso8601String(),
      'emetteur_id': _emetteur?.id,
      'recepteur_id': _recepteur?.id
    };
  }
}
