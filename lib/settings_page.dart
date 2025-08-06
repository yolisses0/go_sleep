import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enabled = false;

  void _onEnabledChange(bool value) {
    setState(() {
      _enabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text('Enabled'),
              Switch(value: _enabled, onChanged: _onEnabledChange),
            ],
          ),
        ],
      ),
    );
  }
}
