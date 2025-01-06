import 'package:authenticator/constants/constants.dart';
import 'package:authenticator/data/providers/group_provider.dart';
import 'package:authenticator/ui/notifications/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../data/providers/auth_item_provider.dart';
import '../../data/providers/data_provider.dart';
import '../../models/auth_item.dart';
import '../../services/otp/otp_service.dart';
import '../../tools/logger.dart';

class AddSecretScreen extends StatefulWidget {
  const AddSecretScreen({super.key});

  @override
  AddSecretScreenState createState() => AddSecretScreenState();
}

class AddSecretScreenState extends State<AddSecretScreen> {
  GroupProvider get groupProvider =>
      Provider.of<GroupProvider>(context, listen: false);

  AuthItemProvider get authItemProvider =>
      Provider.of<AuthItemProvider>(context, listen: false);

  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  final OtpService otpService = OtpService();
  Logger logger = Log.logger;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _keyController = TextEditingController();

  String? _selectedKeyType;

  final List<String> _keyTypes = ['TOTP', 'HOTP'];

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedKeyType != null) {
      final name = _nameController.text;
      final key = _keyController.text;
      final keyType = _selectedKeyType;
      int groupId = Constants.db.group.defaultGroupId;

      logger.i('Name: $name, Key Type: $keyType');

      if (!otpService.isValidSecret(key)) {
        SnackbarService.showSnackBar('Invalid Base32 Key');
        return;
      }

      _formKey.currentState?.reset();
      setState(() {
        _selectedKeyType = null;
      });

      if (dataProvider.currentGroup != null) {
        groupId = dataProvider.currentGroup!.id!;
      }

      AuthItem authItem = AuthItem(
          name: name,
          serviceName: "serviceName",
          secret: key,
          code: "",
          groupId: groupId);

      int result = await authItemProvider.createAuthItem(authItem);
      String message = 'Secret saved successfully';
      if (result < 0) message = "Couldn't add account";

      SnackbarService.showSnackBar(message);
      dataProvider.refresh(notify: true);

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildNameField(),
              SizedBox(height: 16),
              buildKeyField(),
              SizedBox(height: 16),
              buildKeyTypeDropdownField(),
              SizedBox(height: 32),
              buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Center buildAddButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitForm,
        child: Text('Add Account'),
      ),
    );
  }

  DropdownButtonFormField<String> buildKeyTypeDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Key Type',
        hintText: "Select Key Type",
        border: OutlineInputBorder(),
      ),
      value: _selectedKeyType,
      items: _keyTypes.map((String keyType) {
        return DropdownMenuItem<String>(
          value: keyType,
          child: Text(keyType),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedKeyType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a key type' : null,
    );
  }

  TextFormField buildKeyField() {
    return TextFormField(
      controller: _keyController,
      decoration: InputDecoration(
        labelText: 'Key (Base32)',
        hintText: "Enter key",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a key';
        }
        return null;
      },
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: "Enter Account Name",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
    );
  }

  AuthItem getSampleData() {
    return AuthItem(
        name: 'name',
        serviceName: 'serviceName',
        secret: DateTime.now().toUtc().toIso8601String(),
        code: 'code1');
  }
}
