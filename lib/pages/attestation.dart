import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';

class AttestationPage extends StatelessWidget {
  const AttestationPage({super.key, required this.employe});
  final Employe employe;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.back, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    subtitle: const Text('Retour'),
                  ),
                  CommandBarButton(
                    onPressed: () {},
                    label: const Text(
                      "Attestation de travail",
                      style: TextStyle(
                          fontSize: 20, backgroundColor: Colors.white),
                    ),
                    subtitle: Text(
                      'Employe ${employe.matricule}',
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  child: Row(
                    children: const [
                      Text('Imprimer'),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(FluentIcons.print)
                    ],
                  ),
                  onPressed: () {},
                ),
                const Padding(padding: EdgeInsets.all(10)),
                FilledButton(
                  child: Row(
                    children: const [
                      Text('Envoyer'),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(FluentIcons.send)
                    ],
                  ),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
      content: Column(children: []),
      bottomBar: Row(),
    );
  }
}
