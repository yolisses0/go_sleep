import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay? _selectedTime = TimeOfDay(hour: 22, minute: 0);
  bool _isEnabled = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enabled'),
                value: _isEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'Time of the day'),
                onTap: () => _selectTime(context),
                validator: (value) =>
                    _selectedTime == null ? 'Please select a time' : null,
                controller: TextEditingController(
                  text: _selectedTime?.format(context) ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
