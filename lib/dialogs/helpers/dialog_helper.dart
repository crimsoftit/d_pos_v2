import 'package:d_pos_v2/dialogs/exit_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static exit(context) =>
      showDialog(context: context, builder: (context) => ExitConfirmDialog());
}
