import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base/widgets/flavour_banner.dart';
import 'data/providers/auth_item_provider.dart';
import 'data/providers/group_provider.dart';
import 'globals.dart';

void main() {
  runApp(const AuthenticatorApp());
}

class AuthenticatorApp extends StatelessWidget {
  const AuthenticatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => AuthItemProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        title: 'Authenticator',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: FlavorBanner(child: HomeScreen()),
      ),
    );
  }
}
