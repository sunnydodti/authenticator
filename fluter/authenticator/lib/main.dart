import 'package:authenticator/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base/enums.dart';
import 'base/models/flavour_config.dart';
import 'base/models/flavour_values.dart';
import 'data/providers/auth_item_provider.dart';
import 'data/providers/data_provider.dart';
import 'data/providers/group_provider.dart';
import 'data/providers/theme_provider.dart';
import 'services/startup_service.dart';

void main() async {
  await StartUpService.initialize();

  FlavorConfig(
      flavor: Flavor.PRD,
      color: Colors.blue,
      values: FlavorValues(baseUrl: "https://sunnydodti.com/dev"));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => DataProvider()),
      ChangeNotifierProvider(create: (context) => AuthItemProvider()),
      ChangeNotifierProvider(create: (context) => GroupProvider()),
    ],
    child: const AuthenticatorApp(),
  ));
}
