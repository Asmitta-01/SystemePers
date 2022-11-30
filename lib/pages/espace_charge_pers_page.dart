import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Employe.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';

import 'package:systeme_pers/pages/ajouter_employe_page.dart';
import 'package:systeme_pers/pages/gestion_messages_page.dart';
import 'package:systeme_pers/pages/gestion_sanctions_page.dart';
import 'package:systeme_pers/pages/modifier_informations_page.dart';
import 'package:systeme_pers/repositories/employe_repository.dart';
import 'package:systeme_pers/widgets/liste_employes_widget.dart';
import 'package:systeme_pers/widgets/liste_promotions_widget.dart';
import 'package:systeme_pers/widgets/liste_sanctions_widget.dart';
import 'package:systeme_pers/widgets/presentation_documents.dart';
import 'package:systeme_pers/widgets/presentation_suivi.dart';

class EspaceChargePersPage extends StatefulWidget {
  const EspaceChargePersPage({super.key, required this.loggeduser});

  final Utilisateur loggeduser;

  @override
  State<EspaceChargePersPage> createState() => _EspaceChargePersPageState();
}

class _EspaceChargePersPageState extends State<EspaceChargePersPage> {
  var _topIndex = 0;
  var employeRepository = EmployeRepository();
  late Future<Employe?> _currentEmploye;

  @override
  void initState() {
    super.initState();
    _currentEmploye = employeRepository.findByMatricule(widget.loggeduser.matricule);
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ProgressBar(
          activeColor: Colors.blue.darker,
        ));

    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Espace Gestionnaire du personnel',
            style: TextStyle(fontSize: 25, color: Colors.white)),
        height: 75,
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
              // title: FutureBuilder(
              //   future: _currentEmploye,
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return progressBar;
              //     } else {
              //       return const Text('Liste des employes');
              //     }
              //   },
              // ),
              body: FutureBuilder(
                future: _currentEmploye,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return progressBar;
                  } else {
                    return ListeEmplPage(
                      title: 'Liste des employes',
                      logggedEmploye: snapshot.data!,
                    );
                  }
                },
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
                  body: SanctionPage(showForm: false),
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
                  title: const Text('Consulter les contrats'),
                  body: FutureBuilder(
                      future: _currentEmploye,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return progressBar;
                        } else {
                          return ListeEmplPage(
                            title: 'Liste des employes',
                            logggedEmploye: snapshot.data!,
                            optionContrat: true,
                          );
                        }
                      }),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
            PaneItemExpander(
              icon: const Icon(FluentIcons.document_set),
              title: const Text('Etablir des documents'),
              body: const PresentationDocumentsPage(),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.document_approval),
                  title: const Text('Etablir un nouveau contrat de travail'),
                  body: AjouterEmployePage(casEmploye: false),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.certificate),
                  title: const Text('Etablir une attestation de travail'),
                  body: const ListePromotionPage(title: 'Liste des promotions'),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.file_template),
                  title: const Text('Etablir une fiche de renseignement'),
                  body: Container(),
                  selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
            PaneItem(
              icon: const Icon(FluentIcons.inbox),
              title: const Text('Messagerie'),
              body: GestionMessagesPage(
                currentUser: widget.loggeduser,
              ),
              infoBadge: const InfoBadge(source: Text('3')),
              selectedTileColor: ButtonState.all(Colors.blue.withOpacity(0.1)),
            ),
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.edit_contact),
              title: const Text('Modifier vos informations'),
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
