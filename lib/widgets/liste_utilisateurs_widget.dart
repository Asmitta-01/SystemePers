import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/repositories/user_repository.dart';

class ListeUsersPage extends StatefulWidget {
  const ListeUsersPage({super.key, required this.loggedUser});

  final Utilisateur loggedUser;

  @override
  // ignore: no_logic_in_create_state
  State<ListeUsersPage> createState() => _ListeEmplWidget();
}

class _ListeEmplWidget extends State<ListeUsersPage> {
  late Future<List<Utilisateur>> users;

  List<Utilisateur> selectionUsers = [];
  bool checkedEnabled = false;

  var userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    users = userRepository.all(withAdmin: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgressBar(
              activeColor: Colors.blue.darker,
            ),
          );
        } else {
          return ScaffoldPage(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                Checkbox(
                  content: const Text('Tout selectionner'),
                  checked: selectionUsers.toSet().containsAll(snapshot.data!)
                      ? true
                      : selectionUsers.isEmpty
                          ? false
                          : null,
                  onChanged: !checkedEnabled
                      ? null
                      : (value) {
                          setState(() {
                            if (value == true) {
                              selectionUsers.addAll(snapshot.data!);
                            } else {
                              selectionUsers.clear();
                            }
                          });
                        },
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                ToggleSwitch(
                  checked: checkedEnabled,
                  onChanged: (value) {
                    setState(() {
                      checkedEnabled = value;
                      if (!checkedEnabled) selectionUsers.clear();
                    });
                  },
                  content: const Text('Selection multiple'),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      filledButton(
                        icon: FluentIcons.user_followed,
                        text: 'Creer un nouvel utilisateur',
                        fn: () => creerNouvelUtilisateur(context),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    ],
                  ),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            content: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];

                var trailing = SizedBox(
                  width: 320,
                  child: CommandBar(
                    primaryItems: [
                      CommandBarButton(
                        label: const Text('Lire '),
                        icon: const Icon(FluentIcons.view),
                        onPressed: () => confirmerSuppression(context),
                      ),
                      CommandBarButton(
                        label: const Text('Supprimer '),
                        icon: const Icon(FluentIcons.delete),
                        onPressed: user.id == widget.loggedUser.id
                            ? () {}
                            : () => confirmerSuppression(context),
                      ),
                    ],
                  ),
                );

                return ListTile.selectable(
                  title: Text(user.matricule),
                  subtitle: Text(user.role.name),
                  trailing: trailing,
                  selected: selectionUsers.contains(user),
                  tileColor: user.id == widget.loggedUser.id
                      ? ButtonState.all(Colors.warningSecondaryColor)
                      : user.role == Role.admin
                          ? ButtonState.all(Colors.blue.withOpacity(0.1))
                          : null,
                  selectionMode: checkedEnabled
                      ? ListTileSelectionMode.multiple
                      : ListTileSelectionMode.single,
                  onSelectionChange: (selected) {
                    setState(() {
                      if (selected) {
                        if (checkedEnabled) {
                          selectionUsers.add(user);
                        } else {
                          selectionUsers = [user];
                        }
                      } else {
                        selectionUsers.remove(user);
                      }
                    });
                  },
                );
              },
            ),
            bottomBar: selectionUsers.length < 2
                ? null
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Button(
                            child: Text('${selectionUsers.length} selectionne(s)'),
                            onPressed: () {},
                          ),
                        ),
                        filledButton(
                            text: 'Supprimer les utilisateurs de la selection',
                            icon: FluentIcons.delete_table,
                            fn: () => confirmerSuppression(context)),
                      ],
                    ),
                  ),
          );
          ;
        }
      },
    );
  }

  FilledButton filledButton(
      {String text = '', IconData icon = FluentIcons.default_settings, void Function()? fn}) {
    return FilledButton(
      onPressed: fn ?? () {},
      child: Row(
        children: [Text(text), const Padding(padding: EdgeInsets.all(5)), Icon(icon)],
      ),
    );
  }

  creerNouvelUtilisateur(BuildContext context) async {
    var user = await userRepository.createUser();
    final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Creation reussie'),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Identifiants du nouvel utilisateur (Veuillez les copiers, elles ne seront plus accessibles par la suite) :'),
              const Padding(padding: EdgeInsets.all(8)),
              const Text('Matricule : '),
              Text(
                user.matricule,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Mot de passe : '),
              Text(user.motdepasse, style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
        actions: [
          FilledButton(
            child: const Text('Ok, j\'ai note'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }

  confirmerSuppression(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Supprimer des utilisateurs'),
        content: const Text(
            'Vous voulez supprimer des utilisateurs, savez vous ce que cela engendrera ? '),
        actions: [
          Button(
              child: const Text('Oui je le sais, confimer'),
              onPressed: () {
                setState(() {
                  selectionUsers.forEach((element) async {
                    await userRepository.delete(matricule: element.matricule);
                  });
                  selectionUsers.clear();
                });
                Navigator.pop(context, true);
              }),
          FilledButton(
            child: const Text('Non, annuler'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
