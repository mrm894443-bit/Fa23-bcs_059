import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/database_helper.dart';

class AddEditPatientScreen extends StatefulWidget {
  const AddEditPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddEditPatientScreen> createState() => _AddEditPatientScreenState();
}

class _AddEditPatientScreenState extends State<AddEditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _ageCtl = TextEditingController();
  final _addressCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final db = DatabaseHelper();

  Patient? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Patient) {
      editing = args;
      _nameCtl.text = editing!.name;
      _ageCtl.text = editing!.age?.toString() ?? '';
      _addressCtl.text = editing!.address ?? '';
      _phoneCtl.text = editing!.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _ageCtl.dispose();
    _addressCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtl.text.trim();
    final age = int.tryParse(_ageCtl.text.trim());
    final address = _addressCtl.text.trim();
    final phone = _phoneCtl.text.trim();

    if (editing != null) {
      editing!.name = name;
      editing!.age = age;
      editing!.address = address.isEmpty ? null : address;
      editing!.phone = phone.isEmpty ? null : phone;
      await db.updatePatient(editing!);
    } else {
      final p = Patient(
        name: name,
        age: age,
        address: address.isEmpty ? null : address,
        phone: phone.isEmpty ? null : phone,
      );
      await db.insertPatient(p);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editing != null ? 'Edit Patient' : 'Add Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtl,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _ageCtl,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtl,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtl,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 18),
                ElevatedButton(onPressed: _save, child: Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
