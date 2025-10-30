import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../services/database_helper.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final db = DatabaseHelper();
  List<Doctor> doctors = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    setState(() => loading = true);
    doctors = await db.getDoctors();
    setState(() => loading = false);
  }

  void _delete(int id) async {
    await db.deleteDoctor(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctors')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final d = doctors[index];
                return Card(
                  child: ListTile(
                    title: Text(d.name),
                    subtitle: Text(d.specialization ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/add_doctor', arguments: d)
                              .then((_) => _load()),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmDelete(d.id!),
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
        content: Text('Delete this doctor?'),
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
