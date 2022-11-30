import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/repositories/sanction_repository.dart';

import '../classes/Sanction.dart';

class ListeSanctionPage extends StatefulWidget {
  const ListeSanctionPage({super.key, required this.title, required this.callback});

  final String title;
  final Function(Sanction?) callback;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _ListeSanctionWidget(title, callback);
}

class _ListeSanctionWidget extends State<ListeSanctionPage> {
  _ListeSanctionWidget(this.title, this.callback);
  final String title;
  final Function(Sanction?) callback;
  final sanctionRepository = SanctionRepository();

  late Future<List<Future<Sanction>>> sanctions;

  List<Sanction> selectionSanctions = [];
  bool checkedEnabled = false;

  @override
  void initState() {
    super.initState();
    sanctions = sanctionRepository.all();
  }

  @override
  Widget build(BuildContext context) {
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
              FutureBuilder(
                future: sanctions,
                builder: (context, snapshot) => !snapshot.hasData
                    ? ProgressBar(
                        activeColor: Colors.blue.darker,
                      )
                    : Checkbox(
                        content: const Text('Tout selectionner'),
                        checked: selectionSanctions.toSet().containsAll(snapshot.data!)
                            ? true
                            : selectionSanctions.isEmpty
                                ? false
                                : null,
                        onChanged: !checkedEnabled
                            ? null
                            : (value) {
                                setState(() async {
                                  if (value == true) {
                                    for (var elt in snapshot.data!) {
                                      var element = await elt;
                                      selectionSanctions.add(element);
                                    }
                                  } else {
                                    selectionSanctions.clear();
                                  }
                                });
                              },
                      ),
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
                    FilledButton(
                        onPressed: () => callback(null),
                        child: const Text('Sanctionner un employe')),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: FutureBuilder(
        future: sanctions,
        builder: (context, snapshot) => !snapshot.hasData
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  var sanction = snapshot.data![index];
                  return FutureBuilder(
                      future: sanction,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ListTile();
                        } else {
                          var dateSanction = snapshot.data?.dateDeclaration;

                          return ListTile.selectable(
                            selected: selectionSanctions.contains(snapshot.data),
                            selectionMode: checkedEnabled
                                ? ListTileSelectionMode.multiple
                                : ListTileSelectionMode.single,
                            title: (!selectionSanctions.contains(snapshot.data) &&
                                        !checkedEnabled) ||
                                    checkedEnabled
                                ? Text(
                                    snapshot.data!.libelle,
                                  )
                                : Expander(
                                    header: Text(
                                      snapshot.data!.libelle,
                                    ),
                                    content: Text(
                                      sanction.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    initiallyExpanded: true,
                                    onStateChanged: (value) {
                                      setState(() {
                                        if (value != true) selectionSanctions.remove(snapshot.data);
                                      });
                                    },
                                  ),
                            subtitle: (!selectionSanctions.contains(snapshot.data) &&
                                        !checkedEnabled) ||
                                    checkedEnabled
                                ? Text(snapshot.data!.motif)
                                : snapshot.data!.estActive
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            FilledButton(
                                                child: const Text('Modifier la duree'),
                                                onPressed: () {}),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                            ),
                                            FilledButton(
                                                style: ButtonStyle(
                                                    backgroundColor: ButtonState.all(Colors.red)),
                                                onPressed: () => confirmerAnnulation(context),
                                                child: const Text('Mettre fin a la sanction')),
                                          ],
                                        ),
                                      )
                                    : Container(),
                            onPressed: () {
                              setState(() {
                                if (selectionSanctions.contains(snapshot.data))
                                  selectionSanctions.remove(snapshot.data);
                                else {
                                  if (!checkedEnabled) selectionSanctions.clear();
                                  selectionSanctions.add(snapshot.data!);
                                }
                              });
                            },
                            trailing: Row(
                              children: [
                                snapshot.data!.estActive
                                    ? Text(
                                        'Active',
                                        style: TextStyle(
                                            color: Colors.green.lighter,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : snapshot.data!.dateAnnulation != null
                                        ? Text(
                                            'Annule',
                                            style: TextStyle(
                                                color: Colors.red.lightest,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Expire',
                                            style: TextStyle(color: Colors.grey[50]),
                                          ),
                                const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                                Text(
                                  '${dateSanction?.day}-${dateSanction?.month}-${dateSanction?.year}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          );
                        }
                      });
                }),
              ),
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
