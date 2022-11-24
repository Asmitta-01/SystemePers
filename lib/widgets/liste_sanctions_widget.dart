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

  Sanction? selectedSanction;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 1),
          ),
        ),
        width: 700,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: ListView.builder(
          itemCount: sanctions.length,
          itemBuilder: ((context, index) {
            var sanction = sanctions[index];
            var dateSanction = sanction.dateDeclaration;

            return ListTile.selectable(
                selected: selectedSanction == sanction,
                selectionMode: ListTileSelectionMode.single,
                title: Text(
                  sanction.libelle,
                ),
                subtitle: Text(sanction.motif),
                onPressed: () {
                  setState(() {
                    selectedSanction = sanction;
                    // selectedSanction?.annuler();
                  });
                },
                trailing: Row(
                  children: [
                    sanction.estActive
                        ? Text(
                            'Active',
                            style: TextStyle(
                                color: Colors.green.lighter,
                                fontWeight: FontWeight.bold),
                          )
                        : sanction.dateAnnulation != null
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
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20)),
                    Text(
                      '${dateSanction.day}-${dateSanction.month}-${dateSanction.year}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    )
                  ],
                ));
          })),
    );
  }
}
