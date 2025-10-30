import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/database_helper.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final db = DatabaseHelper();
  List<Patient> patients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    setState(() => loading = true);
    patients = await db.getPatients();
    setState(() => loading = false);
  }

  void _delete(int id) async {
    await db.deletePatient(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patients')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final p = patients[index];
                return Card(
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text('Age: ${p.age ?? '-'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/add_patient', arguments: p)
                              .then((_) => _load()),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmDelete(p.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete'),
        content: Text('Delete this patient?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _delete(id);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
