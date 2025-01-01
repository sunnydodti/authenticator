import 'package:authenticator/data/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/group.dart';

class GroupTile extends StatefulWidget {
  final Group group;

  const GroupTile({super.key, required this.group});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(widget.group.name),
      onTap: () {
        Provider.of<DataProvider>(context, listen: false)
            .setCurrentGroup(widget.group, refreshData: true);
      },
    );
  }
}
