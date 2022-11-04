import 'package:flutter/cupertino.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptynotesdialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Sharing",
      content: "you cannot share an empty dialog",
      optionBuilder: () => {
            'OK': null,
          });
}
