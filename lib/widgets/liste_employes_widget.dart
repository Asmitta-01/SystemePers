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
  _ListeEmplWidget(this.optionContrat);
  final bool optionContrat;
  late Future<List<Future<Employe>>> employes;

  List<Employe> selectionEmpls = [];
  bool checkedEnabled = false;

  var employeRepository = EmployeRepository();

  @override
  void initState() {
    super.initState();
    employes = employeRepository.all(avecContrat: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                            if (value == true) {
                              snapshot.data!.forEach((element) async {
                                var data = await element;
                                selectionEmpls.add(data);
                              });
                            } else {
                              selectionEmpls.clear();
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
                        child: FutureBuilder(
                          future: employe,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return ProgressBar(
                                activeColor: Colors.blue.darker,
                              );
                            } else {
                              return CommandBar(primaryItems: [
                                CommandBarButton(
                                    label: const Text('Contrats de travail'),
                                    icon: const Icon(FluentIcons.document_set),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        FluentPageRoute(
                                          builder: (context) =>
                                              FicheRenseignementPage(employe: snapshot.data!),
                                        ),
                                      );
                                    }),
                              ]);
                            }
                          },
                        ))
                    : SizedBox(
                        width: 370,
                        child: FutureBuilder(
                            future: employe,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return ProgressBar(
                                  activeColor: Colors.blue.darker,
                                );
                              } else {
                                return CommandBar(
                                  primaryItems: [
                                    CommandBarButton(
                                      label: const Text('Fiche renseignement'),
                                      icon: const Icon(FluentIcons.file_template),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          FluentPageRoute(
                                            builder: (context) =>
                                                FicheRenseignementPage(employe: snapshot.data!),
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
                                              employe: snapshot.data!,
                                              currentEmploye: widget.logggedEmploye,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                            }),
                      );

                return FutureBuilder(
                    future: employe,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ListTile(
                          title: ProgressBar(
                            activeColor: Colors.blue.darker,
                          ),
                        );
                      } else {
                        return ListTile.selectable(
                          title:
                              Text("${snapshot.data?.nom.toUpperCase()} ${snapshot.data?.prenom}"),
                          subtitle: snapshot.data!.postes.isNotEmpty
                              ? Text(snapshot.data!.postes.last.poste)
                              : const Text('- - - - -'),
                          trailing: trailing,
                          selected: selectionEmpls.contains(snapshot.data),
                          selectionMode: checkedEnabled
                              ? ListTileSelectionMode.multiple
                              : ListTileSelectionMode.single,
                          onSelectionChange: (selected) {
                            setState(() {
                              if (selected) {
                                if (checkedEnabled) {
                                  selectionEmpls.add(snapshot.data!);
                                } else {
                                  selectionEmpls = [snapshot.data!];
                                }
                              } else
                                selectionEmpls.remove(employe);
                            });
                          },
                        );
                      }
                    });
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
