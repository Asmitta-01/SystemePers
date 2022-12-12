import 'package:fluent_ui/fluent_ui.dart';
import 'package:systeme_pers/classes/Promotion.dart';
import 'package:systeme_pers/forms/promotion_form.dart';

import 'package:systeme_pers/repositories/promotion_repository.dart';
import 'package:systeme_pers/utility.dart';
import 'package:systeme_pers/widgets/liste_promotions_widget.dart';

class PromotionPage extends StatefulWidget {
  bool showForm;
  PromotionPage({super.key, required this.showForm});

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  final _promotionRepository = PromotionRepository();

  callback(Promotion? promotion) {
    setState(() {
      if (promotion != null) {
        _promotionRepository.add(promotion: promotion);
        Future.delayed(
          Duration.zero,
          () => infoDialog(context,
              title: 'Nouvelle promotion effectuee',
              content: "Vous venez de promouvoir une nouvelle promotion a un employe.."),
        );
        widget.showForm = false;
      } else {
        widget.showForm = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showForm == false) {
      return ListePromotionPage(
        title: 'Liste des promotions ',
        callback: callback,
      );
    } else {
      return PromotionForm(
        callback: callback,
      );
    }
  }
}
