import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/forms/contrat_form.dart';
import 'package:systeme_pers/forms/employe_Form.dart';

import 'package:systeme_pers/classes/Contrat.dart';
import 'package:systeme_pers/pages/espace_charge_pers_page.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

class AjouterEmployePage extends StatefulWidget {
  bool casEmploye;

  AjouterEmployePage({super.key, required this.casEmploye});

  @override
  State<AjouterEmployePage> createState() => _AjouterEmployePageState();
}

class _AjouterEmployePageState extends State<AjouterEmployePage> {
  Employe? employe;
  Contrat? contrat;

  late EmployeRepository _employeRepository;

  callbackContrat(Contrat ctr) {
    setState(() {
      contrat = ctr;
      if (contrat!.employeDefini) {
        employe = contrat!.employe;
      }
      widget.casEmploye = true;
    });
  }

  callbackEmploye(Employe empl) {
    setState(() {
      employe = empl;
      widget.casEmploye = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (employe != null && contrat != null) {
      _employeRepository = EmployeRepository();
      _employeRepository.add(employe: employe!, contrat: contrat!);
      Future.delayed(Duration.zero, () => informNouvelEmploye(context));

      return Container();
    } else {
      return widget.casEmploye == false
          ? ContratForm(
              callback: callbackContrat,
              empl: employe,
            )
          : EmployeForm(
              callback: callbackEmploye,
              contrat: contrat,
            );
    }
  }

  informNouvelEmploye(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(widget.casEmploye == true && employe != null
            ? "Nouvea contrat cree"
            : "Nouvel employe ajoute"),
        content: Text(widget.casEmploye == true && employe != null
            ? "L'empoye ${employe!.matricule} a un nouveau contrat de travail (Nouveau poste: ${contrat!.poste.poste}."
            : "L'employe nouvellement ajoute est de matricule ${employe!.matricule}."),
        actions: [
          FilledButton(
            child: const Text('Ok, j\'ai compris'),
            onPressed: () {
              setState(() {
                if (widget.casEmploye == false) employe = null;
                if (widget.casEmploye == true) contrat = null;
              });
              Navigator.pop(context, true);
              // Navigator.pushReplacement(
              //     context,
              //     FluentPageRoute(
              //         builder: (context) =>  EspaceChargePersPage()));
            },
          ),
        ],
      ),
    );
  }
}
