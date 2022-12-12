import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Poste.dart';
import 'package:systeme_pers/classes/Promotion.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/repositories/poste_repository.dart';
import 'package:systeme_pers/utility.dart';

class PromotionForm extends StatefulWidget {
  final Function(Promotion) callback;

  const PromotionForm({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _PromotionFormState();
}

class _PromotionFormState extends State<PromotionForm> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _ancPosteController = TextEditingController();
  final _nouvPosteController = TextEditingController();

  String? errorTitre, errorSender, errorAncien;

  Promotion? _promotion;
  Employe? receiver;
  Poste? ancienPoste, nouvPoste;

  var employeRepository = EmployeRepository();
  var posteRepository = PosteRepository();
  late Future<List<Employe>> _employes;
  late Future<List<Poste>> _postes;

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
          'Formulaire de promotion',
          style: TextStyle(fontSize: 25),
        ),
      ),
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Form(
          key: _formKey,
          child: Column(
            children: [
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
                            placeholder: 'Choisissez celui qui benefiecera de cette promotion',
                            items: snapshot.data!
                                .map((e) => AutoSuggestBoxItem(value: e, label: e.nom))
                                .toList(),
                            onSelected: (value) {
                              setState(() {
                                receiver = value.value;
                                receiver!.chargerContrats();
                              });
                            },
                          )),
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              receiver == null
                  ? progressBar
                  : FutureBuilder(
                      future: receiver!.chargerContrats(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InfoLabel(
                            label: errorAncien != null ? errorAncien! : 'Ancien poste',
                            child: SizedBox(
                                width: 300,
                                child: AutoSuggestBox(
                                  controller: _ancPosteController,
                                  placeholder: 'Choisissez l\'ancien poste',
                                  items: receiver!.postes
                                      .map((p) => AutoSuggestBoxItem(value: p, label: p.poste))
                                      .toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      ancienPoste = value.value;
                                    });
                                  },
                                )),
                          );
                        } else {
                          return progressBar;
                        }
                      },
                    ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FormRow(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(color: Colors.black),
                child: InfoLabel(
                  label: 'Nouveau poste de l\'employe',
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
                                nouvPoste =
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
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FilledButton(
                  child: const Text(
                    'Creer nouvelle promotion',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_receiverController.text.isEmpty || receiver == null) {
                        setState(() {
                          errorSender = "Vous devez choisir une cible pour cette promotion";
                        });
                      } else if (_ancPosteController.text.isEmpty) {
                        setState(() {
                          errorAncien = "Vous devez choisir le poste qui va disparaitre";
                        });
                      } else {
                        setState(() {
                          errorTitre = null;
                          _promotion = Promotion(
                              employe: receiver!,
                              ancienPoste: ancienPoste!,
                              nouveauPoste: nouvPoste!);
                        });
                        widget.callback(_promotion!);
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
