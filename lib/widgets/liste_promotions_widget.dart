import 'package:fluent_ui/fluent_ui.dart';

import 'package:systeme_pers/classes/Promotion.dart';
import 'package:systeme_pers/repositories/promotion_repository.dart';

class ListePromotionPage extends StatefulWidget {
  const ListePromotionPage({super.key, required this.title, required this.callback});

  final String title;
  final Function callback;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _ListePromotionWidget(title);
}

class _ListePromotionWidget extends State<ListePromotionPage> {
  _ListePromotionWidget(this.title);
  final String title;
  bool checkedEnabled = false;

  var promotionRepository = PromotionRepository();
  late Future<List<Future<Promotion>>?> promotions;

  // Promotion? selectedPromotion;
  List<Promotion> selectionPromotions = [];

  @override
  void initState() {
    super.initState();
    promotions = promotionRepository.all();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(width: 1),
              ),
            ),
            // width: 700,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10, right: 135),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              FutureBuilder(
                future: promotions,
                builder: (context, snapshot) => !snapshot.hasData
                    ? ProgressBar(
                        activeColor: Colors.blue.darker,
                      )
                    : Checkbox(
                        content: const Text('Tout selectionner'),
                        checked: selectionPromotions.toSet().containsAll(snapshot.data!)
                            ? true
                            : selectionPromotions.isEmpty
                                ? false
                                : null,
                        onChanged: !checkedEnabled
                            ? null
                            : (value) {
                                setState(() async {
                                  if (value == true) {
                                    for (var elt in snapshot.data!) {
                                      var element = await elt;
                                      selectionPromotions.add(element);
                                    }
                                  } else {
                                    selectionPromotions.clear();
                                  }
                                });
                              },
                      ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              ToggleSwitch(
                checked: checkedEnabled,
                onChanged: (value) {
                  setState(() {
                    checkedEnabled = value;
                    if (!checkedEnabled) selectionPromotions.clear();
                  });
                },
                content: const Text('Selection multiple'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                        onPressed: () => widget.callback(null),
                        child: const Text('Nouvelle promotion')),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      // content: ListView.builder(
      //   itemCount: promotions.length,
      //   itemBuilder: ((context, index) {
      //     var promotion = promotions![index];
      //     var datePromotion = promotion.datePromotion;

      //     return ListTile.selectable(
      //         selected: selectedPromotion == promotion,
      //         selectionMode: ListTileSelectionMode.single,
      //         title: Text(promotion.toString()),
      //         subtitle: Text('Beneficiaire: ${promotion.employe.matricule}'),
      //         onPressed: () {
      //           setState(() {
      //             selectedPromotion = promotion;
      //             // selectedPromotion?.annuler();
      //           });
      //         },
      //         trailing: Row(
      //           children: [
      //             Text(
      //               'attribuee le ${datePromotion.day}-${datePromotion.month}-${datePromotion.year}',
      //               style: const TextStyle(fontStyle: FontStyle.italic),
      //             )
      //           ],
      //         ));
      //   }),
      // ),
    );
  }
}
