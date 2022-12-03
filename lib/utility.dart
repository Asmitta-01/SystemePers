import 'package:fluent_ui/fluent_ui.dart';

Widget get progressBar => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ProgressBar(
        activeColor: Colors.blue.darker,
      ),
    );

FilledButton filledButton(
    {String text = '', IconData? icon, bool danger = false, void Function()? fn}) {
  return FilledButton(
    onPressed: fn ?? () {},
    style: danger ? ButtonStyle(backgroundColor: ButtonState.all(Colors.red)) : null,
    child: Row(
      children: [Text(text), const Padding(padding: EdgeInsets.all(5)), Icon(icon)],
    ),
  );
}

infoDialog(BuildContext context,
    {required String title, required String content, Function? addFn}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FilledButton(
          child: const Text('D\'accord'),
          onPressed: () {
            Navigator.pop(context, true);
            addFn;
          },
        )
      ],
    ),
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
