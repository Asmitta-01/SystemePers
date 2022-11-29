import 'package:fluent_ui/fluent_ui.dart';

import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/pages/ajouter_employe_page.dart';
import 'package:systeme_pers/pages/attestation.dart';
import 'package:systeme_pers/pages/fiche_renseignement.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

class ListeEmplPage extends StatefulWidget {
  const ListeEmplPage(
      {super.key, required this.title, this.optionContrat = false, required this.logggedEmploye});

  final String title;
  final bool optionContrat;
  final Employe logggedEmploye;

  @override
  // ignore: no_logic_in_create_state
  State<ListeEmplPage> createState() => _ListeEmplWidget(optionContrat);
}

class _ListeEmplWidget extends State<ListeEmplPage> {
  _ListeEmplWidget(this.optionContrat) {
    currentEmploye = widget.logggedEmploye;
  }
  final bool optionContrat;
  Future<List<Employe>>? employes;

  List<Employe> selectionEmpls = [];
  bool checkedEnabled = false;

  var employeRepository = EmployeRepository();
  Employe? currentEmploye;

  @override
  void initState() {
    super.initState();
    employes = employeRepository.all();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employe>>(
      future: employes,
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
                const Padding(padding: EdgeInsets.all(10)),
                Checkbox(
                  content: const Text('Tout selectionner'),
                  checked: selectionEmpls.toSet().containsAll(snapshot.data!)
                      ? true
                      : selectionEmpls.isEmpty
                          ? false
                          : null,
                  onChanged: !checkedEnabled
                      ? null
                      : (value) {
                          setState(() {
                            if (value == true)
                              selectionEmpls.addAll(snapshot.data!);
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
                if (!optionContrat)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        filledButton(
                            icon: FluentIcons.add_friend,
                            text: 'Ajouter nouvel employe',
                            fn: () {
                              Navigator.pushReplacement(
                                context,
                                FluentPageRoute(
                                    builder: (context) => AjouterEmployePage(casEmploye: true)),
                              );
                            }),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      ],
                    ),
                  )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            content: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final employe = snapshot.data![index];

                var trailing = optionContrat
                    ? SizedBox(
                        width: 200,
                        child: CommandBar(primaryItems: [
                          CommandBarButton(
                            label: const Text('Contrats de travail'),
                            icon: const Icon(FluentIcons.document_set),
                            onPressed: () {
                              Navigator.push(
                                context,
                                FluentPageRoute(
                                  builder: (context) => FicheRenseignementPage(employe: employe),
                                ),
                              );
                            },
                          ),
                        ]))
                    : SizedBox(
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
                                    builder: (context) => FicheRenseignementPage(employe: employe),
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
                                    builder: (context) => AttestationPage(
                                      employe: employe,
                                      currentEmploye: currentEmploye!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );

                return ListTile.selectable(
                  title: Text("${employe.nom.toUpperCase()} ${employe.prenom}"),
                  subtitle: Text(employe.postes.last.poste),
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
                          text: 'Imprimer les contrats de travail de la selection',
                          icon: FluentIcons.print,
                        ),
                      ],
                    ),
                  ),
          );
          ;
        }
      },
    );
  }

  FilledButton filledButton(
      {String text = '', IconData icon = FluentIcons.default_settings, void Function()? fn}) {
    return FilledButton(
      onPressed: fn ?? () {},
      child: Row(
        children: [Text(text), const Padding(padding: EdgeInsets.all(5)), Icon(icon)],
      ),
    );
  }
}
