import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Sanction.dart';
import 'package:systeme_pers/forms/sanction_form.dart';

import 'package:systeme_pers/repositories/sanction_repository.dart';
import 'package:systeme_pers/widgets/liste_sanctions_widget.dart';

class SanctionPage extends StatefulWidget {
  bool showForm;
  SanctionPage({super.key, required this.showForm});

  @override
  State<SanctionPage> createState() => _SanctionPageState();
}

class _SanctionPageState extends State<SanctionPage> {
  final _sanctionRepository = SanctionRepository();

  callback(Sanction? sanction) {
    setState(() {
      if (sanction != null) {
        _sanctionRepository.add(sanction: sanction);
        Future.delayed(Duration.zero, () => informNouvelleSanction(context));
        widget.showForm = false;
      } else {
        widget.showForm = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showForm == false) {
      return ListeSanctionPage(
        title: 'Liste des sanctions ',
        callback: callback,
      );
    } else {
      return SanctionForm(
        callback: callback,
      );
    }
  }

  informNouvelleSanction(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Nouvelle sanction ajoutee'),
        content: const Text("Vous venez d''infliger une nouvelle sanction a un employe.."),
        actions: [
          FilledButton(
            child: const Text('Ok, j\'ai compris'),
            onPressed: () {
              setState(() => Navigator.pop(context, true));
            },
          )
        ],
      ),
    );
  }
}
