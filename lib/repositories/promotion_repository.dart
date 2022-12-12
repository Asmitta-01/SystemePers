import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Promotion.dart';
import 'package:http/http.dart' as http;

class PromotionRepository {
  Future<List<Future<Promotion>>?> findAllForEmploye(int idEmploye) async {
    final response =
        await http.get(Uri.parse('http://localhost/syspers/promotion.php?id_empl=$idEmploye'));
    debugPrint('Fecthing Promotions for Employe...');
    if (response.statusCode == 200) {
      var results = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      debugPrint('Fetching promotion for user $idEmploye');
      return results.map((c) => Promotion.fromJSON(c)).toList();
    }

    return null;
  }

  Future<List<Future<Promotion>>?> all() async {
    final response = await http.get(Uri.parse('http://localhost/syspers/promotion.php'));

    if (response.statusCode != 401) {
      List<dynamic> results = jsonDecode(response.body);
      debugPrint('Fetching all Promotions');
      return results.map((c) => Promotion.fromJSON(c)).toList();
    }

    return null;
  }

  add({required Promotion promotion}) async {
    final response = await http.post(
      Uri.parse('http://localhost/syspers/promotion.php'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(promotion.toJSON()),
    );
    debugPrint('Saving promotion...');
    if (response.statusCode == 201) {
      debugPrint('Saved');
    } else {
      debugPrint(response.body);
    }
  }
}
