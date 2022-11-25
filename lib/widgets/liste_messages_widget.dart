import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Message.dart';

class ListeMessagesPage extends StatefulWidget {
  const ListeMessagesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListeMessagesPageState();
}

class _ListeMessagesPageState extends State<ListeMessagesPage> {
  final _messages = listeMessages;
  List<Message> selectionMsgs = [];
  bool checkedEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          Checkbox(
            content: const Text('Tout selectionner'),
            checked: selectionMsgs.toSet().containsAll(_messages)
                ? true
                : selectionMsgs.isEmpty
                    ? false
                    : null,
            onChanged: !checkedEnabled
                ? null
                : (value) {
                    setState(() {
                      if (value == true)
                        selectionMsgs.addAll(_messages);
                      else
                        selectionMsgs.clear();
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
                    icon: FluentIcons.add_friend,
                    text: 'Envoyer nouveau message',
                    fn: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   FluentPageRoute(builder: (context) => AjouterEmployePage(casEmploye: true)),
                      // );
                    }),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              ],
            ),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];

          var trailing = SizedBox(
            width: 370,
            child: CommandBar(
              primaryItems: [
                CommandBarButton(
                  label: const Text('Imprimer'),
                  icon: const Icon(FluentIcons.print),
                  onPressed: () {},
                ),
                CommandBarButton(
                  label: const Text('Supprimer'),
                  icon: const Icon(FluentIcons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          );

          return ListTile.selectable(
            title: Text(message.titre.toUpperCase()),
            subtitle: Text(message.dateEnvoi.toString()),
            trailing: trailing,
            selected: selectionMsgs.contains(message),
            selectionMode:
                checkedEnabled ? ListTileSelectionMode.multiple : ListTileSelectionMode.single,
            onSelectionChange: (selected) {
              setState(() {
                if (selected) {
                  if (checkedEnabled)
                    selectionMsgs.add(message);
                  else
                    selectionMsgs = [message];
                } else
                  selectionMsgs.remove(message);
              });
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

  confirmerSuppression(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text("Voulez-vous vous lever cette sanction ?"),
        content: const Text(
            "Vous decidez de lever la sanction donnee a cet employe. En etes vous sur ?"),
        actions: [
          Button(
            child: const Text('Oui, lever la sanction'),
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

  FilledButton filledButton(
      {String text = '',
      IconData icon = FluentIcons.default_settings,
      bool danger = false,
      void Function()? fn}) {
    return FilledButton(
      onPressed: fn ?? () {},
      style: danger ? ButtonStyle(backgroundColor: ButtonState.all(Colors.red)) : null,
      child: Row(
        children: [Text(text), const Padding(padding: EdgeInsets.all(5)), Icon(icon)],
      ),
    );
  }
}
