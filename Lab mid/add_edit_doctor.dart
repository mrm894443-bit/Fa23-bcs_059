import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../services/database_helper.dart';

class AddEditDoctorScreen extends StatefulWidget {
  const AddEditDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddEditDoctorScreen> createState() => _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends State<AddEditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _specCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final db = DatabaseHelper();

  Doctor? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Doctor) {
      editing = args;
      _nameCtl.text = editing!.name;
      _specCtl.text = editing!.specialization ?? '';
      _phoneCtl.text = editing!.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _specCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtl.text.trim();
    final spec = _specCtl.text.trim();
    final phone = _phoneCtl.text.trim();

    if (editing != null) {
      editing!.name = name;
      editing!.specialization = spec.isEmpty ? null : spec;
      editing!.phone = phone.isEmpty ? null : phone;
      await db.updateDoctor(editing!);
    } else {
      final d = Doctor(
        name: name,
        specialization: spec.isEmpty ? null : spec,
        phone: phone.isEmpty ? null : phone,
      );
      await db.insertDoctor(d);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editing != null ? 'Edit Doctor' : 'Add Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                controller: _specCtl,
                decoration: InputDecoration(labelText: 'Specialization'),
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
    );
  }
}
