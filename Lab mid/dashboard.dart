import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  Widget buildButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(route),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        backgroundColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          height: 72,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 12),
              Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            buildButton(
              context,
              'Add Doctor',
              Icons.person_add_alt_1,
              '/add_doctor',
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Add Patient',
              Icons.person_add,
              '/add_patient',
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Doctor Database',
              Icons.medical_information,
              '/doctors',
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Patient Database',
              Icons.folder_shared,
              '/patients',
            ),
          ],
        ),
      ),
    );
  }
}
