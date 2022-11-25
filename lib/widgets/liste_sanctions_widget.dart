import 'package:fluent_ui/fluent_ui.dart';

import '../classes/Sanction.dart';

class ListeSanctionPage extends StatefulWidget {
  const ListeSanctionPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _ListeSanctionWidget(title);
}

class _ListeSanctionWidget extends State<ListeSanctionPage> {
  _ListeSanctionWidget(this.title);
  final String title;
  final List<Sanction> sanctions = listeSanctions;

  List<Sanction> selectionSanctions = [];
  bool checkedEnabled = false;

  @override
  Widget build(BuildContext context) {
    sanctions.sort((s1, s2) => s1.dateDeclaration.compareTo(s2.dateDeclaration));

    return ScaffoldPage(
      header: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(width: 1),
              ),
            ),
            // width: 700,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10, right: 135),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Checkbox(
                content: const Text('Tout selectionner'),
                checked: selectionSanctions.toSet().containsAll(sanctions)
                    ? true
                    : selectionSanctions.isEmpty
                        ? false
                        : null,
                onChanged: !checkedEnabled
                    ? null
                    : (value) {
                        setState(() {
                          if (value == true)
                            selectionSanctions.addAll(sanctions);
                          else
                            selectionSanctions.clear();
                        });
                      },
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              ToggleSwitch(
                checked: checkedEnabled,
                onChanged: (value) {
                  setState(() {
                    checkedEnabled = value;
                    if (!checkedEnabled) selectionSanctions.clear();
                  });
                },
                content: const Text('Selection multiple'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(onPressed: () {}, child: const Text('Sanctionner un employe')),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: ListView.builder(
        itemCount: sanctions.length,
        itemBuilder: ((context, index) {
          var sanction = sanctions[index];
          var dateSanction = sanction.dateDeclaration;

          return ListTile.selectable(
            selected: selectionSanctions.contains(sanction),
            selectionMode:
                checkedEnabled ? ListTileSelectionMode.multiple : ListTileSelectionMode.single,
            title: (!selectionSanctions.contains(sanction) && !checkedEnabled) || checkedEnabled
                ? Text(
                    sanction.libelle,
                  )
                : Expander(
                    header: Text(
                      sanction.libelle,
                    ),
                    content: Text(sanction.toString()),
                    initiallyExpanded: true,
                    onStateChanged: (value) {
                      setState(() {
                        if (value != true) selectionSanctions.remove(sanction);
                      });
                    },
                  ),
            subtitle: (!selectionSanctions.contains(sanction) && !checkedEnabled) || checkedEnabled
                ? Text(sanction.motif)
                : sanction.estActive
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FilledButton(child: const Text('Modifier la duree'), onPressed: () {}),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                            ),
                            FilledButton(
                                style: ButtonStyle(backgroundColor: ButtonState.all(Colors.red)),
                                onPressed: () => confirmerAnnulation(context),
                                child: const Text('Mettre fin a la sanction')),
                          ],
                        ),
                      )
                    : Container(),
            onPressed: () {
              setState(() {
                if (selectionSanctions.contains(sanction))
                  selectionSanctions.remove(sanction);
                else {
                  if (!checkedEnabled) selectionSanctions.clear();
                  selectionSanctions.add(sanction);
                }
              });
            },
            trailing: Row(
              children: [
                sanction.estActive
                    ? Text(
                        'Active',
                        style: TextStyle(color: Colors.green.lighter, fontWeight: FontWeight.bold),
                      )
                    : sanction.dateAnnulation != null
                        ? Text(
                            'Annule',
                            style:
                                TextStyle(color: Colors.red.lightest, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'Expire',
                            style: TextStyle(color: Colors.grey[50]),
                          ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                Text(
                  '${dateSanction.day}-${dateSanction.month}-${dateSanction.year}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )
              ],
            ),
          );
        }),
      ),
      bottomBar:
          !(selectionSanctions.length > 1 && selectionSanctions.any((element) => element.estActive))
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
                          child: Text('${selectionSanctions.length} selectionne(s)'),
                          onPressed: () => {},
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      FilledButton(
                          onPressed: () => confirmerAnnulation(context),
                          style: ButtonStyle(
                            backgroundColor: ButtonState.all(Colors.red),
                            padding: ButtonState.all(
                                const EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
                          ),
                          child: const Text('Lever toutes les sanctions selectionnees')),
                    ],
                  ),
                ),
    );
  }

  confirmerAnnulation(BuildContext context) async {
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
                selectionSanctions.forEach((element) {
                  element.annuler();
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
