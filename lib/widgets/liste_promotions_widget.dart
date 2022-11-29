import 'package:fluent_ui/fluent_ui.dart';

import '../classes/Promotion.dart';

class ListePromotionPage extends StatefulWidget {
  const ListePromotionPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _ListePromotionWidget(title);
}

class _ListePromotionWidget extends State<ListePromotionPage> {
  _ListePromotionWidget(this.title);
  final String title;
  List<Promotion>? promotions;

  Promotion? selectedPromotion;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 1),
          ),
        ),
        width: 700,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      content: promotions == null
          ? Column(
              children: [
                Expanded(
                    child: ProgressBar(
                  activeColor: Colors.blue.darker,
                ))
              ],
            )
          : ListView.builder(
              itemCount: promotions!.length,
              itemBuilder: ((context, index) {
                var promotion = promotions![index];
                var datePromotion = promotion.datePromotion;

                return ListTile.selectable(
                    selected: selectedPromotion == promotion,
                    selectionMode: ListTileSelectionMode.single,
                    title: Text(promotion.toString()),
                    subtitle: Text('Beneficiaire: ${promotion.employe.matricule}'),
                    onPressed: () {
                      setState(() {
                        selectedPromotion = promotion;
                        // selectedPromotion?.annuler();
                      });
                    },
                    trailing: Row(
                      children: [
                        Text(
                          'attribuee le ${datePromotion.day}-${datePromotion.month}-${datePromotion.year}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    ));
              })),
    );
  }
}
