import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../globals.dart';

class SnackbarService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  static void emptyFunction() {}

  //region Section 2: SnackBarWithoutContext
  static showSnackBar(String message,
      {bool removeCurrent = false, int duration = 2}) {
    SnackBar snackBar = SnackBar(content: Text(message));
    if (removeCurrent) snackbarKey.currentState!.removeCurrentSnackBar();
    snackbarKey.currentState!.showSnackBar(snackBar);
  }

  static showErrorSnackBar(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    if (removeCurrent) snackbarKey.currentState!.removeCurrentSnackBar();
    snackbarKey.currentState!.showSnackBar(snackBar);
  }

  static showSuccessSnackBar(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) async {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    if (removeCurrent) snackbarKey.currentState!.removeCurrentSnackBar();
    snackbarKey.currentState!.showSnackBar(snackBar);
  }

  static Future<bool> showUndoSnackBar(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) async {
    Completer<bool> completer = Completer<bool>();
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          completer.complete(true);
        },
      ),
    );
    if (removeCurrent) snackbarKey.currentState!.removeCurrentSnackBar();
    snackbarKey.currentState!.showSnackBar(snackBar);
    await Future.delayed(const Duration(seconds: 5));

    if (!completer.isCompleted) {
      completer.complete(false);
    }
    return completer.future;
  }

  static showUndoSnackBarCallback(
      BuildContext context, String message, Function onUndo,
      {bool removeCurrent = false,
      int duration = 2,
      Function onNotUndo = emptyFunction}) async {
    bool isUndoPressed = false;

    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          isUndoPressed = true;
          onUndo();
        },
      ),
    );
    if (removeCurrent) snackbarKey.currentState!.removeCurrentSnackBar();
    snackbarKey.currentState!.showSnackBar(snackBar);

    await Future.delayed(const Duration(seconds: 5));
    _logger.i("undo: $isUndoPressed");
    if (isUndoPressed == false) onNotUndo();
  }
//endregion
}
