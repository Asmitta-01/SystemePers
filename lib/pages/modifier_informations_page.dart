import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/forms/employe_Form.dart';
import 'package:systeme_pers/pages/espace_employe_page.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

class ModifierInfosPage extends StatefulWidget {
  ModifierInfosPage({super.key, required this.emlpoye});

  Employe emlpoye;

  @override
  State<StatefulWidget> createState() => _ModifierInfosPageState();
}

class _ModifierInfosPageState extends State<ModifierInfosPage> {
  var employeRepository = EmployeRepository();

  callback(Employe employe) {
    setState(() {
      widget.emlpoye = employe;
      employeRepository.update(employe: employe);
      Future.delayed(Duration.zero, () => informNouvelEmploye(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: EmployeForm(
        callback: callback,
        employe: widget.emlpoye,
      ),
    );
  }

  informNouvelEmploye(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Mise a jour reussie'),
        content: const Text('Vos informations ont bien ete mise a jour'),
        actions: [
          FilledButton(
            child: const Text('Ok, j\'ai compris'),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pushReplacement(
                  context,
                  FluentPageRoute(
                      builder: (context) => EspaceEmployePage(
                            loggeduser: widget.emlpoye,
                          )));
            },
          ),
        ],
      ),
    );
  }
}
