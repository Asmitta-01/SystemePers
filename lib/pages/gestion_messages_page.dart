import 'package:fluent_ui/fluent_ui.dart';

import 'package:systeme_pers/forms/message_form.dart';
import 'package:systeme_pers/widgets/liste_messages_widget.dart';

class GestionMessagesPage extends StatefulWidget {
  bool envoyerMessage;
  GestionMessagesPage({super.key, this.envoyerMessage = false});

  @override
  State<GestionMessagesPage> createState() => _GestionMessagesPageState(envoyerMessage);
}

class _GestionMessagesPageState extends State<GestionMessagesPage> {
  _GestionMessagesPageState(this.envoyerMessage);
  bool envoyerMessage;

  callback() {
    setState(() {
      envoyerMessage = !envoyerMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (envoyerMessage) {
      return MessageForm(callback: callback);
    } else {
      return ListeMessagesPage(
        callback: callback,
      );
    }
  }
}
