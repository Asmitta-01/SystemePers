import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';

import 'package:systeme_pers/classes/Utilisateur.dart';

import 'package:systeme_pers/pages/gestion_messages_page.dart';
import 'package:systeme_pers/pages/modifier_informations_page.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';

class EspaceEmployePage extends StatefulWidget {
  const EspaceEmployePage({super.key, required this.loggeduser});

  final Utilisateur loggeduser;

  @override
  State<EspaceEmployePage> createState() => _EspaceEmployePageState();
}

class _EspaceEmployePageState extends State<EspaceEmployePage> {
  var _topIndex = 0;
  var employeRepository = EmployeRepository();

  Future<Employe?>? _currentEmploye;

  @override
  void initState() {
    super.initState();
    debugPrint('Employe Page: Fetched user : ${widget.loggeduser.matricule}');
    _currentEmploye = employeRepository.find(widget.loggeduser.id!);
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ProgressBar(
      activeColor: Colors.blue.darker,
    );

    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Espace Employe de l\'Universite',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        height: 75,
        leading: const Icon(
          FluentIcons.employee_self_service,
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
              icon: const Icon(FluentIcons.inbox),
              title: const Text('Messagerie'),
              body: GestionMessagesPage(),
              infoBadge: const InfoBadge(source: Text('1')),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.edit_contact),
              title: FutureBuilder(
                future: _currentEmploye,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return progressBar;
                  } else {
                    return const Text('Modifier vos informations');
                  }
                },
              ),
              body: FutureBuilder(
                  future: _currentEmploye,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return progressBar;
                    } else {
                      return ModifierInfosPage(emlpoye: snapshot.data!);
                    }
                  }),
              selectedTileColor: ButtonState.all(Colors.blue.lightest),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.sign_out),
              title: const Text('Se deconnecter'),
              body: Container(),
              onTap: () => mieeAjour(context),
            )
          ]),
    );
  }

  mieeAjour(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text("Voulez-vous vous deconnecter ?"),
        content: const Text("Vous avez demande a vous deconnecter. En etes vous sur ?"),
        actions: [
          Button(
            child: const Text('Je veux me deconnecter'),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          FilledButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
