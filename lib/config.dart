import 'package:buzzit/main.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Config {
  static AlertStyle get alertConfig {
    return AlertStyle(
      backgroundColor: MyApp.myColor.shade50,
      alertAlignment: Alignment.center,
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        color: MyApp.myColor.shade700,
        fontWeight: FontWeight.normal,
        fontFamily: 'OpenSans',
        fontSize: 20,
      ),
      titleStyle: TextStyle(
        color: MyApp.myColor.shade700,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'OpenSans',
      ),
      descTextAlign: TextAlign.center,
      animationDuration: const Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }
}
