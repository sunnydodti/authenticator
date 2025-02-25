import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/data/providers/theme_provider.dart';
import 'package:authenticator/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base/widgets/flavour_banner.dart';
import 'data/providers/auth_item_provider.dart';
import 'data/providers/group_provider.dart';
import 'globals.dart';
import 'services/startup_service.dart';

void main() async {
  await StartUpService.initialize();
  runApp(const AuthenticatorApp());
}

class AuthenticatorApp extends StatelessWidget {
  const AuthenticatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      title: 'Authenticator',
      theme: context.watch<ThemeProvider>().theme,
      home: FlavorBanner(child: HomeScreen()),
    );
  }
}
