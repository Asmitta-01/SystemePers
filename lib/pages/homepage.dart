import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Sanction.dart';
import 'package:systeme_pers/widgets/liste_employes_widget.dart';
import 'package:systeme_pers/widgets/liste_promotions_widget.dart';
import 'package:systeme_pers/widgets/liste_sanctions_widget.dart';
import 'package:systeme_pers/widgets/presentation_suivi.dart';

import '../classes/Employe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _topIndex = 0;

  final _employes = listEmployes;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Espace Gestionnaire du personnel',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        height: 70,
        leading: const Icon(
          FluentIcons.manager_self_service,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.darker,
      ),
      pane: NavigationPane(
          selected: _topIndex,
          onChanged: (index) => setState(() {
                _topIndex = index;
              }),
          size: const NavigationPaneSize(openMaxWidth: 300),
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.task_list),
              title: const Text('Liste des employes'),
              body: ListeEmplPage(
                title: 'Liste des employes',
                employes: _employes,
              ),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
            PaneItemExpander(
              icon: const Icon(FluentIcons.see_do),
              title: const Text('Consulter le suivi'),
              body: const PresentationSuiviPage(),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.distribute_down),
                  title: const Text('Consulter les sanctions'),
                  body: const ListeSanctionPage(title: 'Liste des sanctions '),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.promoted_database),
                  title: const Text('Consulter les promotions'),
                  body: const ListePromotionPage(title: 'Liste des promotions'),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.contact_card),
                  title: const Text('Etablir un contrat de travail'),
                  body: Container(),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
            PaneItem(
              icon: const Icon(FluentIcons.inbox),
              title: const Text('Messagerie'),
              body: const Text('Pane 03'),
              infoBadge: const InfoBadge(source: Text('3')),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.edit_contact),
              title: const Text('Modifier vos informations'),
              body: const Text('Ok'),
              selectedTileColor: ButtonState.all(Colors.blue.lightest),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.sign_out),
              title: const Text('Se deconnecter'),
              body: Container(),
              onTap: () => confirmerDeconnexion(context),
            )
          ]),
    );
  }

  confirmerDeconnexion(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text("Voulez-vous vous deconnecter ?"),
        content: const Text("Vous avez demande a vous deconnecter. En etes vous sur ?"),
        actions: [
          Button(
            child: const Text('Je veux me deconnecter'),
            onPressed: () {
              Navigator.pop(context, 'UserLoggingOut');
            },
          ),
          FilledButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.pop(context, 'UserCancelledLogOut');
            },
          )
        ],
      ),
    );

    setState(() {
      print(result);
    });
  }
}
