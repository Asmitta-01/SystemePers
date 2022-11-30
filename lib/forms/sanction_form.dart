import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Sanction.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

class SanctionForm extends StatefulWidget {
  final Function(Sanction) callback;

  const SanctionForm({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _SanctionFormState();
}

class _SanctionFormState extends State<SanctionForm> {
  final _formKey = GlobalKey<FormState>();

  final _libelleController = TextEditingController();
  final _motifController = TextEditingController();
  final _detailsController = TextEditingController();
  final _receiverController = TextEditingController();

  String? errorTitre, errorSender, errorMotif;
  Sanction? _sanction;
  Utilisateur? receiver;
  int _duration = 5;

  var employeRepository = EmployeRepository();
  late Future<List<Future<Employe>>> _employes;

  @override
  void initState() {
    super.initState();
    _employes = employeRepository.all(avecContrat: false);
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
          'Formulaire de sanction',
          style: TextStyle(fontSize: 25),
        ),
      ),
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              FormRow(
                error: errorTitre != null ? Text(errorTitre!) : null,
                child: TextBox(controller: _libelleController, header: 'Libelle de la sanction'),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                error: errorMotif != null ? Text(errorMotif!) : null,
                child: TextBox(
                  controller: _motifController,
                  header: 'Motif de la sanction',
                  enableSuggestions: true,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                child: TextBox(
                  controller: _detailsController,
                  header: 'Details (Explications)',
                  maxLines: 5,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FutureBuilder(
                future: _employes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ProgressBar(
                      activeColor: Colors.blue.darker,
                    );
                  } else {
                    return InfoLabel(
                      label: errorSender != null ? errorSender! : 'Cible',
                      child: SizedBox(
                          width: 300,
                          child: AutoSuggestBox(
                            controller: _receiverController,
                            placeholder: 'Choisissez celui qui ecopera de cette sanction',
                            items: snapshot.data!.map((e) {
                              return AutoSuggestBoxItem(value: e, label: e.toString());
                            }).toList(),
                            onSelected: (value) {
                              setState(() {
                                // receiver = value.value;
                              });
                            },
                          )),
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                child: InfoLabel(
                  label: 'Determinez la duree du contrat (en jours): $_duration jours',
                  child: Slider(
                    min: 1,
                    max: 90,
                    value: _duration.toDouble(),
                    label: 'Duree de la sanction',
                    onChanged: (value) {
                      setState(() {
                        _duration = value.toInt();
                      });
                    },
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FilledButton(
                  child: const Text(
                    'Envoyer sanction',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_libelleController.text.isEmpty) {
                        setState(() {
                          errorTitre = "Votre sanction doit avoir un libelle";
                        });
                      } else if (_receiverController.text.isEmpty || receiver == null) {
                        setState(() {
                          errorSender = "Vous devez choisir une cible pour cette sanction";
                        });
                      } else if (_motifController.text.isEmpty) {
                        setState(() {
                          errorMotif = "Vous devez definir le motif de cette sanction";
                        });
                      } else {
                        setState(() {
                          errorTitre = null;
                          // _sanction = Sanction(
                          //     employe: receiver,
                          //     libelle: _libelleController.text,
                          //     motif: _motifController.text,
                          //     details: _detailsController.text,
                          //     dateSanction: DateTime.now().toIso8601String(),
                          //     dureeSanction: _duration);
                        });
                      }
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}
