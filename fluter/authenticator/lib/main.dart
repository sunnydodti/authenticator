import 'package:authenticator/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers/auth_item_provider.dart';
import 'data/providers/group_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthItemProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: MaterialApp(
        title: 'Authenticator',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
