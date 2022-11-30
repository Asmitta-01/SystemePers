import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:systeme_pers/classes/Message.dart';

class MessageRepository {
  add({required Message message}) async {
    final response = await http.post(
      Uri.parse('http://localhost/syspers/message.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(message.toJSON()),
    );
    debugPrint('Sending message...');
    if (response.statusCode == 400) {
      debugPrint(response.body);
    } else {
      debugPrint('Sent');
    }
  }

  Future<List<Future<Message>>> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/message.php'));
    List<dynamic> results = jsonDecode(response.body);

    debugPrint('Fetched all messagees...');

    return results.map((e) => Message.fromJSON(e)).toList();
  }

  Future<List<Future<Message>>> allForUser(int idUser) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/message.php?user_id=$idUser'));
    // if (response.statusCode == 200) {

    List<dynamic> results = jsonDecode(response.body);
    debugPrint('Fetched all messagees for user $idUser...');
    return results.map((e) => Message.fromJSON(e)).toList();
    // }
  }

  deleteForUser({required int idUser, required bool emetteur}) async {
    final response = await http.patch(
      Uri.parse('http://localhost/syspers/message.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'id_user': idUser, 'emetteur': emetteur}),
    );
    debugPrint('Hiding message for user $idUser');
    if (response.statusCode == 401) {
      debugPrint(response.body);
    } else {
      debugPrint('Hidden');
    }
  }
}
