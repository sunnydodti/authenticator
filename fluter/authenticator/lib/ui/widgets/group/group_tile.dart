import 'package:authenticator/data/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/group.dart';

class GroupTile extends StatefulWidget {
  final Group group;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onSelect;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const GroupTile({
    super.key,
    required this.group,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onSelect,
    required this.onToggle,
    required this.onTap,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;
    onTap() {
      if (widget.isSelectionMode) {
        widget.onTap();
        return;
      }
      viewGroup(context);
    }

    if (widget.isSelected) {
      color = Colors.blue.withAlpha(50);
    }
    return Container(
      color: color,
      child: ListTile(
        selected: widget.isSelected,
        onLongPress: widget.onSelect,
        onTap: onTap,
        leading: const Icon(Icons.folder_outlined),
        title: Text(widget.group.name),
        trailing: widget.isSelected
            ? IconButton(
                onPressed: widget.onToggle,
                icon: Icon(Icons.check_box),
              )
            : null,
      ),
    );
  }

  void viewGroup(BuildContext context) {
    return Provider.of<DataProvider>(context, listen: false)
        .setCurrentGroup(widget.group, refreshData: true);
  }
}
