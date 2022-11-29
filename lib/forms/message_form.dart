import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Message.dart';
import 'package:systeme_pers/session_manager.dart';

class MessageForm extends StatefulWidget {
  final Function() callback;

  const MessageForm({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();

  String? errorTitre, errorContenu;
  var session = SessionManager();

  Message? _message;
  Employe? currentEmploye;

  @override
  void initState() {
    session.getCurrentEmploye().then((value) => currentEmploye = value);
    super.initState();
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
              'Tout employe a un contrat. Creer un nouvel employe implique creer un nouveau contrat.\n'),
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
                              from: currentEmploye);
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
