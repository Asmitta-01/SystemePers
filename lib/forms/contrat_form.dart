import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/repositories/poste_repository.dart';

class ContratForm extends StatefulWidget {
  const ContratForm({super.key, this.empl, required this.callback});
  final Employe? empl;
  final Function(Contrat) callback;

  @override
  State<StatefulWidget> createState() => _ContratFormState(empl: empl, callback: callback);
}

class _ContratFormState extends State<ContratForm> {
  _ContratFormState({this.empl, required this.callback}) {
    if (empl != null) {
      matriculEmpl = empl!.matricule;
      receiveEmpl = true;
    }
  }

  Employe? empl;
  Function(Contrat) callback;
  bool receiveEmpl = false;

  final _formKey = GlobalKey<FormState>();
  Future<List<Poste>>? _postes;
  Future<List<Employe>>? _employes;

  Poste? _selectedPoste;
  double _durationValue = 90;
  double _preavisValue = 30;
  double _hebdoValue = 30;
  String? matriculEmpl;
  int? typeContrat = 0;
  bool nouvelEmploye = true;
  final _salaireController = TextEditingController();
  final _clausesController = TextEditingController();

  Contrat? _contrat;

  var employeRepository = EmployeRepository();
  var posteRepository = PosteRepository();

  @override
  void initState() {
    super.initState();

    _employes = employeRepository.all();
    _postes = posteRepository.all();
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
          'Formulaire de contrat de travail',
          style: TextStyle(fontSize: 25),
        ),
      ),
      children: [
        const InfoBar(
          title: Text('Information'),
          content: Text(
              'Tout contrat correspond a un poste et un employe. Si l\'employe correspondant n\'existe pas encore vous aurez a le creer par la suite.\n' +
                  'Desactiver le choix "Nouvel employe" pour choisir un employe existant.'),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Type de contrat : '),
                  ...List.generate(
                    2,
                    (index) => RadioButton(
                      checked: typeContrat == index,
                      content: Text(index == 0 ? 'CDD' : 'CDI'),
                      onChanged: ((value) {
                        if (value) {
                          setState(() {
                            typeContrat = index;
                          });
                        }
                      }),
                    ),
                  )
                ],
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                child: InfoLabel(
                  label:
                      'Determinez la duree du contrat (en jours): ${_durationValue.toInt()} jours',
                  child: Slider(
                    min: 15,
                    max: 735,
                    value: _durationValue,
                    label: 'Duree du contrat',
                    onChanged: typeContrat == 1
                        ? null
                        : (value) {
                            setState(() {
                              _durationValue = value;
                            });
                          },
                  ),
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: _salaireController,
                  header: 'Salaire (en F CFA)',
                  placeholder: '10 000',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || num.tryParse(value) == null)
                      return 'Veuillez entrer le salaire (de type entier/flottant)';
                    else if (num.tryParse(value)! < 30000)
                      return 'Le salaire doit etre superieur ou egale a 30 000 F CFA';
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Cilbe du contrat : '),
                  ToggleSwitch(
                    checked: nouvelEmploye,
                    content: const Text('Nouvel employe'),
                    onChanged: receiveEmpl
                        ? (value) {}
                        : ((value) {
                            setState(() {
                              nouvelEmploye = value;
                            });
                          }),
                  ),
                  InfoLabel(
                    label: 'Employe cible',
                    child: SizedBox(
                        width: 300,
                        child: receiveEmpl
                            ? const Text('')
                            : FutureBuilder(
                                future: _employes,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return ProgressBar(
                                      activeColor: Colors.blue.darker,
                                    );
                                  } else {
                                    return AutoSuggestBox(
                                      placeholder: 'Choisissez l\'employe via son matricule',
                                      items: snapshot.data!
                                          .map((e) => AutoSuggestBoxItem(
                                              value: e.matricule, label: e.matricule))
                                          .toList(),
                                      enabled: !nouvelEmploye,
                                      onSelected: (value) {
                                        setState(() {
                                          matriculEmpl = value.label;
                                        });
                                      },
                                    );
                                  }
                                },
                              )),
                  )
                ],
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                child: InfoLabel(
                  label: 'Poste du contrat',
                  child: FutureBuilder(
                    future: _postes,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ProgressBar(
                          activeColor: Colors.blue.darker,
                        );
                      } else {
                        return ComboboxFormField(
                          icon: const Icon(FluentIcons.post_update),
                          iconSize: 15,
                          placeholder: const Text('Choisir un poste'),
                          items: snapshot.data!
                              .map((e) => ComboBoxItem(
                                    value: e.poste,
                                    child: Text(e.poste),
                                  ))
                              .toList(),
                          onChanged: ((value) => setState(() {
                                _selectedPoste =
                                    snapshot.data!.singleWhere((element) => element.poste == value);
                              })),
                          validator: ((value) {
                            return value == null || value.toString().isEmpty
                                ? "Veuillez choisir un poste"
                                : null;
                          }),
                        );
                      }
                    },
                  ),
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                error: _preavisValue < _durationValue
                    ? null
                    : const Text(
                        'La periode de preavis ne peut etre superieure ou egale a la duree du contrat'),
                child: InfoLabel(
                  label:
                      'Determinez la duree du preavis (en jours): ${_preavisValue.toInt()} jours',
                  child: Slider(
                    min: 3,
                    max: 90,
                    value: _preavisValue,
                    label: 'Duree du contrat',
                    onChanged: typeContrat == 1
                        ? null
                        : (value) {
                            setState(() {
                              _preavisValue = value;
                            });
                          },
                  ),
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                child: InfoLabel(
                  label:
                      'Specifez le nombre d\'heures de travail de l\'employe par semaine: ${_hebdoValue.toInt()} heures',
                  child: Slider(
                    min: 12,
                    max: 140,
                    value: _hebdoValue,
                    label: 'Nombre d\'heures par semaine',
                    onChanged: (value) {
                      setState(() {
                        _hebdoValue = value;
                      });
                    },
                  ),
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: _clausesController,
                  header: 'Clauses supplementaires',
                  placeholder: 'Autres termes du contrat',
                  maxLines: 10,
                ),
              ),
              FutureBuilder(
                future: _employes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ProgressBar(
                      activeColor: Colors.blue.darker,
                    );
                  } else {
                    return FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _contrat = Contrat();
                            _contrat!.dureeContrat = Duration(days: _durationValue.toInt());
                            _contrat!.salaire = num.tryParse(_salaireController.text)!.toDouble();
                            _contrat!.dureePreavis = Duration(days: _preavisValue.toInt());
                            _contrat!.nbrHeuresTravail = Duration(hours: _hebdoValue.toInt());
                            _contrat!.clausesSupp = _clausesController.text;
                            _contrat!.poste = _selectedPoste!;

                            if (!nouvelEmploye) {
                              _contrat!.employe = snapshot.data!
                                  .singleWhere((element) => element.matricule == matriculEmpl);
                            }

                            callback(_contrat!);
                          });
                        }
                      },
                      child: const Text(
                        'Creer le contrat',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
