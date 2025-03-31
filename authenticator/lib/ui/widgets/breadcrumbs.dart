import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/models/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Breadcrumbs extends StatefulWidget {
  const Breadcrumbs({super.key});

  @override
  State<Breadcrumbs> createState() => _BreadcrumbsState();
}

class _BreadcrumbsState extends State<Breadcrumbs> {
  final ScrollController _scrollController = ScrollController();

  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.brightness == Brightness.light
          ? Colors.blue.shade50.withAlpha(200)
          : Colors.blue.shade800.withAlpha(25),
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 50,
      child: Consumer<DataProvider>(
        builder: (context, provider, child) {
          List<Widget> breadcrumbs = [];

          if (provider.groupStack.isEmpty) breadcrumbs.add(buildSeprator());

          for (var group in provider.groupStack) {
            breadcrumbs.add(buildSeprator());
            breadcrumbs.add(buildBreadcrumbText(group));
          }
          _scrollToEnd();
          return Row(
            children: [
              IconButton(
                onPressed: () => provider.popCurrentGroup(refreshData: true),
                icon: Icon(Icons.chevron_left_outlined),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: breadcrumbs,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  GestureDetector buildBreadcrumbText(Group group) => GestureDetector(
        child: Text(group.name),
        onTap: () {
          dataProvider.resetStackTo(group);
        },
      );

  Text buildSeprator() => Text(" / ");
}
