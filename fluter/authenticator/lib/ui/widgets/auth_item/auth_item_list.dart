import 'package:authenticator/ui/widgets/auth_item/auth_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/auth_item_provider.dart';
import '../../../models/auth_item.dart';

class AuthItemList extends StatefulWidget {
  const AuthItemList({super.key});

  @override
  State<AuthItemList> createState() => _AuthItemListState();
}

class _AuthItemListState extends State<AuthItemList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthItemProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: provider.authItems.isEmpty
                ? Text('Empty')
                : Scrollbar(
                    interactive: true,
                    radius: const Radius.circular(5),
                    child: ListView.builder(
                        itemCount: provider.authItems.length,
                        itemBuilder: (context, index) {
                          AuthItem authItem = provider.authItems[index];
                          return AuthItemTile(authItem: authItem);
                        })));
      },
    );
  }
}
