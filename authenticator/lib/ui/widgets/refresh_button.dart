import 'package:authenticator/data/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return IconButton(
          onPressed: () => provider.refresh(notify: true),
          icon: Icon(Icons.refresh),
        );
      },
    );
  }
}
