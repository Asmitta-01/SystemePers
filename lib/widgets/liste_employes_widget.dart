import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/pages/attestation.dart';
import 'package:systeme_pers/pages/fiche_renseignement.dart';

class ListeEmplPage extends StatefulWidget {
  const ListeEmplPage({super.key, required this.title, required this.employes});

  final String title;
  final List<Employe> employes;

  @override
  // ignore: no_logic_in_create_state
  State<ListeEmplPage> createState() => _ListeEmplWidget(employes: employes);
}

class _ListeEmplWidget extends State<ListeEmplPage> {
  _ListeEmplWidget({required this.employes});
  final List<Employe> employes;

  List<Employe> selectionEmpls = [];
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
            checked: selectionEmpls.toSet().containsAll(employes)
                ? true
                : selectionEmpls.isEmpty
                    ? false
                    : null,
            onChanged: !checkedEnabled
                ? null
                : (value) {
                    setState(() {
                      if (value == true)
                        selectionEmpls.addAll(employes);
                      else
                        selectionEmpls.clear();
                    });
                  },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          ToggleSwitch(
            checked: checkedEnabled,
            onChanged: (value) {
              setState(() {
                checkedEnabled = value;
                if (!checkedEnabled) selectionEmpls.clear();
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
                    text: 'Ajouter nouvel employe'),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              ],
            ),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: ListView.builder(
        itemCount: employes.length,
        itemBuilder: (context, index) {
          final employe = employes[index];

          var trailing = SizedBox(
            width: 370,
            child: CommandBar(
              primaryItems: [
                CommandBarButton(
                  label: const Text('Fiche renseignement'),
                  icon: const Icon(FluentIcons.file_template),
                  onPressed: () {
                    Navigator.push(
                      context,
                      FluentPageRoute(
                        builder: (context) =>
                            FicheRenseignementPage(employe: employe),
                      ),
                    );
                  },
                ),
                CommandBarButton(
                  label: const Text('Attestation de travail'),
                  icon: const Icon(FluentIcons.certificate),
                  onPressed: () {
                    Navigator.push(
                      context,
                      FluentPageRoute(
                        builder: (context) => AttestationPage(employe: employe),
                      ),
                    );
                  },
                ),
              ],
            ),
          );

          return ListTile.selectable(
            title: Text(employe.nom),
            subtitle: Text(employe.role.name.uppercaseFirst()),
            trailing: trailing,
            selected: selectionEmpls.contains(employe),
            selectionMode: checkedEnabled
                ? ListTileSelectionMode.multiple
                : ListTileSelectionMode.single,
            onSelectionChange: (selected) {
              setState(() {
                if (selected) {
                  if (checkedEnabled)
                    selectionEmpls.add(employe);
                  else
                    selectionEmpls = [employe];
                } else
                  selectionEmpls.remove(employe);
              });
            },
          );
        },
      ),
      bottomBar: selectionEmpls.length < 2
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
                      child: Text('${selectionEmpls.length} selectionne(s)'),
                      onPressed: () => {},
                    ),
                  ),
                  filledButton(
                    text: 'Imprimer les fiches de la selection',
                    icon: FluentIcons.print,
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  filledButton(
                    text: 'Envoyer les fiches de la selection',
                    icon: FluentIcons.send,
                  ),
                ],
              ),
            ),
    );
  }

  FilledButton filledButton(
      {String text = '',
      IconData icon = FluentIcons.default_settings,
      void Function()? fn}) {
    return FilledButton(
        onPressed: fn ?? () {},
        child: Row(
          children: [
            Text(text),
            const Padding(padding: EdgeInsets.all(5)),
            Icon(icon)
          ],
        ));
  }
}
