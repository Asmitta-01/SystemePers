import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';

import 'package:systeme_pers/classes/Utilisateur.dart';

import 'package:systeme_pers/pages/gestion_messages_page.dart';
import 'package:systeme_pers/pages/modifier_informations_page.dart';
import 'package:systeme_pers/repositories/user_repository.dart';
import 'package:systeme_pers/widgets/liste_utilisateurs_widget.dart';

class EspaceAdminPage extends StatefulWidget {
  const EspaceAdminPage({super.key, required this.loggeduser});

  final Utilisateur loggeduser;

  @override
  State<EspaceAdminPage> createState() => _EspaceAdminPageState();
}

class _EspaceAdminPageState extends State<EspaceAdminPage> {
  var _topIndex = 0;
  var userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Espace Administrateur',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        height: 75,
        leading: const Icon(
          FluentIcons.admin,
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
              icon: const Icon(FluentIcons.page_list),
              title: const Text('Liste des utilisateurs'),
              body: ListeUsersPage(loggedUser: widget.loggeduser),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.inbox),
              title: const Text('Messagerie'),
              body: GestionMessagesPage(
                currentUser: widget.loggeduser,
              ),
              // infoBadge: const InfoBadge(source: Text('1')),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
          ],
          footerItems: [
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
              // Navigator.popUntil(context, (route) => false);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          FilledButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}
