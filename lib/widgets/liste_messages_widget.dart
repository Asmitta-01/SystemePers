import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Message.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/pages/lire_message.dart';
import 'package:systeme_pers/repositories/message_repository.dart';
import 'package:systeme_pers/utility.dart';

class ListeMessagesPage extends StatefulWidget {
  const ListeMessagesPage({super.key, required this.callback, required this.user});
  final Function callback;
  final Utilisateur user;

  @override
  State<StatefulWidget> createState() => _ListeMessagesPageState();
}

class _ListeMessagesPageState extends State<ListeMessagesPage> {
  // final _messages = listeMessages;
  List<Message> selectionMsgs = [];
  bool checkedEnabled = false;

  var messageRepository = MessageRepository();
  late Future<List<Future<Message>>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = messageRepository.allForUser(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _messages,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ProgressBar(
            activeColor: Colors.blue.darker,
          );
        } else {
          return ScaffoldPage(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
                Checkbox(
                  content: const Text('Tout selectionner'),
                  checked: selectionMsgs.toSet().containsAll(snapshot.data!)
                      ? true
                      : selectionMsgs.isEmpty
                          ? false
                          : null,
                  onChanged: !checkedEnabled
                      ? null
                      : (value) {
                          setState(() {
                            if (value == true) {
                              // selectionMsgs.addAll(snapshot.data);
                            } else {
                              selectionMsgs.clear();
                            }
                          });
                        },
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                ToggleSwitch(
                  checked: checkedEnabled,
                  onChanged: (value) {
                    setState(() {
                      checkedEnabled = value;
                      if (!checkedEnabled) selectionMsgs.clear();
                    });
                  },
                  content: const Text('Selection multiple'),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      filledButton(
                          icon: FluentIcons.new_mail,
                          text: 'Envoyer nouveau message',
                          fn: () {
                            setState(() => widget.callback());
                          }),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    ],
                  ),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            content: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // final message = snapshot.data![index];
                final Future<Message> message = snapshot.data![index];

                return FutureBuilder(
                  future: message,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile();
                    } else {
                      return ListTile.selectable(
                        title: Text(
                          snapshot.data!.titre.uppercaseFirst(),
                          style: TextStyle(
                              fontWeight: snapshot.data!.emetteur.id != widget.user.id &&
                                      snapshot.data!.estNonLu
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                        subtitle: Text(snapshot.data!.dateEnvoi.toString()),
                        leading: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: snapshot.data!.recepteur.id == widget.user.id
                                ? Icon(FluentIcons.download, color: Colors.green)
                                : Icon(FluentIcons.upload, color: Colors.red)),
                        trailing: SizedBox(
                          width: 240,
                          child: CommandBar(
                            primaryItems: [
                              CommandBarButton(
                                label: const Text('Lire'),
                                icon: const Icon(FluentIcons.view),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      FluentPageRoute(
                                        builder: (context) =>
                                            LireMessagePage(message: snapshot.data!),
                                      ));
                                },
                              ),
                              CommandBarButton(
                                label: const Text('Supprimer'),
                                icon: const Icon(FluentIcons.delete),
                                onPressed: () => confirmerSuppression(context),
                              ),
                            ],
                          ),
                        ),
                        selected: selectionMsgs.contains(snapshot.data),
                        selectionMode: checkedEnabled
                            ? ListTileSelectionMode.multiple
                            : ListTileSelectionMode.single,
                        onSelectionChange: (selected) {
                          setState(() {
                            if (selected) {
                              if (checkedEnabled)
                                selectionMsgs.add(snapshot.data!);
                              else
                                selectionMsgs = [snapshot.data!];
                            } else
                              selectionMsgs.remove(message);
                          });
                        },
                      );
                    }
                  },
                );
              },
            ),
            bottomBar: selectionMsgs.length < 2
                ? null
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Button(
                            child: Text('${selectionMsgs.length} selectionne(s)'),
                            onPressed: () => {},
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        filledButton(
                          text: 'Supprimer la selection',
                          icon: FluentIcons.delete_columns,
                          danger: true,
                          fn: () => confirmerSuppression(context),
                        ),
                      ],
                    ),
                  ),
          );
        }
      },
    );
  }

  confirmerSuppression(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text("Voulez-vous vous ne plus voir ce message ?"),
        content: const Text("Vous decidez de supprimer ce(s) message(s). En etes vous sur ?"),
        actions: [
          Button(
            child: const Text('Oui, je confirme la suppression'),
            onPressed: () {
              setState(() {
                selectionMsgs.forEach((element) {
                  element.supprimerCoteEmetteur();
                });
                ;
                Navigator.pop(context, 'UserKillSanction');
              });
            },
          ),
          FilledButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.pop(context, 'UserAbortSanctionKill');
            },
          )
        ],
      ),
    );
  }
}
