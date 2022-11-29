import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Utilisateur.dart';
import 'package:systeme_pers/pages/espace_employe_page.dart';
import 'package:systeme_pers/repositories/user_repository.dart';
import 'pages/espace_charge_pers_page.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(), _navKey = GlobalKey<NavigatorState>();

  final _matriculeController = TextEditingController();
  final _motdepasseController = TextEditingController();

  String? errorMdp, errrorMat;
  bool _verificationEnCours = false, _stepOneOk = false;
  Utilisateur? _fetchedUser;
  var userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    if (_verificationEnCours && _stepOneOk) {
      if (_fetchedUser == null) {
        debugPrint('Found');
        setState(() {
          errrorMat = 'Ce matricule n\'est pas reconnu dans la base';
          _verificationEnCours = false;
        });
      } else if (!verificationMotdepasse(mdp: _motdepasseController.text)) {
        setState(() {
          debugPrint('Checked password');
          errorMdp = "Mot de passes incorrect";
          _verificationEnCours = false;
        });
      } else {
        setState(() {
          _verificationEnCours = false;
          _formKey.currentState!.reset();
          _stepOneOk = false;
        });
        if (_fetchedUser!.role == Role.chargePersonnel) {
          _navKey.currentState!.pushNamed('/espacechargedupersonnel');
        } else if (_fetchedUser!.role == Role.employe) {
          _navKey.currentState!.pushNamed('/espaceemploye');
        } else if (_fetchedUser!.role == Role.admin) {
          _navKey.currentState!.pushNamed('/espaceadministrateur');
        }
        debugPrint('Logged');
      }
    }

    var text = _verificationEnCours
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ProgressBar(
              activeColor: Colors.white,
              backgroundColor: Colors.blue.darker,
            ),
          )
        : const Text(
            'Connexion',
            style: TextStyle(fontSize: 18),
          );

    return FluentApp(
      title: 'SystemPers',
      theme: ThemeData(accentColor: Colors.blue),
      navigatorKey: _navKey,
      initialRoute: '/',
      routes: {
        '/espacechargedupersonnel': ((context) => EspaceChargePersPage(
              loggeduser: _fetchedUser!,
            )),
        '/espaceemploye': ((context) => EspaceEmployePage(
              loggeduser: _fetchedUser!,
            )),
        '/espaceadministrateur': ((context) => Container())
      },
      home: Builder(
        builder: (context) {
          return ScaffoldPage(
            content: Acrylic(
              tint: Colors.blue.darkest,
              shadowColor: Colors.black,
              tintAlpha: 0.8,
              blurAmount: 40,
              luminosityAlpha: 0.5,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 1200,
                        decoration: BoxDecoration(
                            color: Colors.blue.darker,
                            border: Border(bottom: BorderSide(color: Colors.blue.darker))),
                        padding: const EdgeInsets.only(top: 50, bottom: 15, left: 15),
                        child: Row(
                          children: const [
                            Text(
                              'SysPers',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Icon(
                              FluentIcons.system,
                              color: Colors.white,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: 1000,
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(width: 1.5))),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text(
                            'Connectez vous pour acceder a votre espace',
                            style: TextStyle(fontSize: 17),
                          )),
                      FormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: TextFormBox(
                          controller: _matriculeController,
                          header: 'Matricule',
                          placeholder: '11SS00',
                          autofocus: true,
                          validator: (value) {
                            return value == null || value.length != 6
                                ? 'Veuillez renseigner votre matricule (06 caracteres)'
                                : errrorMat;
                          },
                        ),
                      ),
                      FormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: TextFormBox(
                          controller: _motdepasseController,
                          header: 'Mot de Passe',
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? 'Veuillez entrer le mot de passe'
                                : errorMdp;
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(30)),
                      FilledButton(
                        onPressed: _verificationEnCours
                            ? () {}
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() {
                                    errorMdp = errrorMat = null;
                                    _verificationEnCours = true;
                                  });
                                  verificationMatricule(matricule: _matriculeController.text);
                                }
                              },
                        child: text,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  verificationMatricule({required String matricule}) {
    if (_fetchedUser == null || _fetchedUser!.matricule != matricule) {
      setState(() {
        _fetchedUser = null;
        debugPrint('Fetching');
      });
      userRepository.getUser(matricule: matricule).then((value) {
        setState(() {
          _fetchedUser = value;
          _stepOneOk = true;
        });
      });
    }
  }

  bool verificationMotdepasse({required String mdp}) {
    return _fetchedUser!.motdepasse == mdp;
  }
}
