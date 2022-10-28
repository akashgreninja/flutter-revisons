import 'package:flutter/cupertino.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Your sure?',
    optionBuilder: () => {
      'Cancel': false,
      'delete': true,
    },
  ).then((value) => value ?? false);
}
