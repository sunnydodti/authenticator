import 'package:authenticator/app.dart';
import 'package:flutter/material.dart';

import 'base/enums.dart';
import 'base/models/flavour_config.dart';
import 'base/models/flavour_values.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRD,
      color: Colors.blue,
      values: FlavorValues(baseUrl: "https://sunnydodti.com/dev"));
  runApp(const AuthenticatorApp());
}