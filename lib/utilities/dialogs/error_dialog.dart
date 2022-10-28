import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    content: text,
    context: context,
    title: 'An Error Occured',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
