import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Message.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/message_repository.dart';
import 'package:systeme_pers/repositories/user_repository.dart';

class MessageForm extends StatefulWidget {
  final Function() callback;
  final Utilisateur user;

  const MessageForm({super.key, required this.callback, required this.user});

  @override
  State<StatefulWidget> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();

  String? errorTitre, errorContenu;
  Message? _message;

  var userRepository = UserRepository();
  Future<List<Utilisateur>>? _users;

  @override
  void initState() {
    super.initState();
    _users = userRepository.all();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 1),
          ),
        ),
        width: 600,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const Text(
          'Formulaire du message',
          style: TextStyle(fontSize: 25),
        ),
      ),
      children: [
        const InfoBar(
          title: Text('Information'),
          content: Text(
              'Pour tout message vous devrez renseigner le titre et le contenu du message et/ou une piece jointe.\n'),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              FormRow(
                error: errorTitre != null ? Text(errorTitre!) : null,
                child: TextBox(controller: _titreController, header: 'Titre du message'),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                error: errorContenu != null ? Text(errorContenu!) : null,
                child: TextBox(
                  controller: _contenuController,
                  header: 'Contenu du message',
                  maxLines: 5,
                  autofillHints: const ['Demande d\'attestation de travail', 'Demande de conges'],
                  enableSuggestions: true,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                error: errorContenu != null ? Text(errorContenu!) : null,
                child: Container(),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ProgressBar(
                      activeColor: Colors.blue.darker,
                    );
                  } else {
                    return AutoSuggestBox(
                      placeholder: 'Choisissez le destinataire de ce message',
                      items: snapshot.data!
                          .map((e) => AutoSuggestBoxItem(value: e, label: e.matricule))
                          .toList(),
                      onSelected: (value) {
                        setState(() {});
                      },
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FilledButton(
                  child: const Text(
                    'Envoyer message',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_titreController.text.isEmpty) {
                        setState(() {
                          errorTitre = "Votre message doit avoir un titre";
                        });
                      } else {
                        setState(() {
                          errorTitre = null;
                          _message = Message(
                              titre: _titreController.text,
                              contenu: _contenuController.text,
                              from: widget.user,
                              to: widget.user);

                          var messageRepository = MessageRepository();
                          messageRepository.add(message: _message!);
                          listeMessages.add(_message!);
                        });
                        envoiOk(context);
                      }
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }

  envoiOk(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text("Message envoye"),
        content: const Text('Votre message a bien ete envoye'),
        actions: [
          FilledButton(
            child: const Text('D\'accord'),
            onPressed: () {
              Navigator.pop(context);
              setState(() => widget.callback());
            },
          )
        ],
      ),
    );
  }
}
