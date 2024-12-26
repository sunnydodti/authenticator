import 'package:authenticator/ui/helpers/navigation_helper.dart';
import 'package:authenticator/ui/screens/add_secret_screen.dart';
import 'package:flutter/material.dart';

import '../screens/scan_secret_screen.dart';

class AddAuthItemButton extends StatefulWidget {
  const AddAuthItemButton({super.key});

  @override
  AddAuthItemButtonState createState() => AddAuthItemButtonState();
}

class AddAuthItemButtonState extends State<AddAuthItemButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isExpanded) ...[
          _buildOption(
              Icon(Icons.camera_alt_outlined), "Scan QR", handleCameraInput),
          _buildOption(Icon(Icons.keyboard_alt_outlined), "Enter Secret",
              handleKeyboardInput),
        ],
        FloatingActionButton(
          onPressed: _toggle,
          child: _isExpanded ? Icon(Icons.clear) : Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildOption(Icon icon, String label, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            margin: EdgeInsets.only(right: 10),
            color: Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: label,
            onPressed: () {
              _toggle();
              onPressed();
            },
            child: icon,
          ),
        ],
      ),
    );
  }

  void handleCameraInput() {
    NavigationHelper.navigateToScreen(context, ScanSecretScreen());
  }

  void handleKeyboardInput() {
    NavigationHelper.navigateToScreen(context, AddSecretScreen());
  }
}
