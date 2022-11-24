import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/widgets/liste_sanctions_widget.dart';

class PresentationSuiviPage extends StatelessWidget {
  const PresentationSuiviPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 1),
          ),
        ),
        width: 600,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const Text(
          'Suivi',
          style: TextStyle(fontSize: 25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: Container(
          margin: const EdgeInsets.only(bottom: 300, top: 20),
          child: InfoBar(
            title: const Text('Operations possibles'),
            severity: InfoBarSeverity.info,
            content: Column(
              children: [
                const Text(
                    'Dans cetet section, vous pouvez effectuer trois(03) principales actions: '),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                FilledButton(
                  child: const Text('Consulter les sanctions'),
                  onPressed: () {},
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                FilledButton(
                  child: const Text('Consulter les promotions'),
                  onPressed: () {},
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                FilledButton(
                  child: const Text('Etablir un contrat de travail'),
                  onPressed: () {},
                )
              ],
            ),
            isLong: false,
          )),
    );
  }
}
