import 'package:authenticator/data/providers/auth_item_provider.dart';
import 'package:authenticator/data/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(builder: (context, value, child) {
      return IconButton(onPressed: (){}, icon: Icon(Icons.refresh));
    },);;
  }
}
