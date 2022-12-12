import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/classes/Employe.dart';

class EmployeForm extends StatefulWidget {
  const EmployeForm({super.key, this.contrat, required this.callback, this.employe});
  final Contrat? contrat;
  final Function(Employe) callback;
  final Employe? employe;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _EmployeFormState();
}

class _EmployeFormState extends State<EmployeForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _cniController = TextEditingController();
  DateTime _dateNaissance = DateTime.now();

  Employe? _employe;

  @override
  void initState() {
    super.initState();
    _dateNaissance = widget.employe == null ? DateTime.now() : widget.employe!.dateNaissance;
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
            'Formulaire de l\'employe',
            style: TextStyle(fontSize: 25),
          ),
        ),
        children: [
          const InfoBar(
            title: Text('Information'),
            content: Text(
                'Tout employe a un contrat. Creer un nouvel employe implique creer un nouveau contrat.\n' +
                    'Si aucun contrat n\'a ete fait jusqu\'a present vous serez amene a en creer un al\'etape suivante.'),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Form(
            key: _formKey,
            child: Column(children: [
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: _nomController,
                  header: 'Nom',
                  initialValue: widget.employe == null ? null : widget.employe!.nom,
                  placeholder: 'Hamat',
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Veuillez entrer le nom de l\'employe (03 caracteres minimum)';
                    }
                  },
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: _prenomController,
                  initialValue: widget.employe == null ? null : widget.employe!.prenom,
                  header: 'Prenoms',
                  placeholder: 'John, Harold, Washington, etc.',
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Veuillez entrer le prenom de l\'employe (03 caracteres minimum)';
                    }
                  },
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: _cniController,
                  header: 'Numero de la Carte d\'Indetite Nationale',
                  initialValue: widget.employe == null ? null : widget.employe!.numeroCni,
                  placeholder: '102101201',
                  validator: (value) {
                    if (value == null || !value.contains(RegExp(r'(\d+)')) || value.length != 9) {
                      return 'Veuillez entrer le numero de CNI de l\'employe (09 chiffres).';
                    }
                  },
                ),
              ),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: DatePicker(
                  selected: _dateNaissance,
                  header: 'Date de naissance de l\'employe',
                  onChanged: (value) {
                    setState(() {
                      _dateNaissance = value;
                    });
                  },
                ),
              ),
              FilledButton(
                  child: const Text(
                    'Creer et ajouter la nouvelle recrue',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _employe = Employe(
                          nom: _nomController.text,
                          contrat: widget.contrat,
                          prenom: _prenomController.text,
                          numeroCni: _cniController.text,
                          dateNaissance: _dateNaissance.toIso8601String(),
                        );

                        widget.callback(_employe!);
                      });
                    }
                  })
            ]),
          )
        ]);
  }
}
