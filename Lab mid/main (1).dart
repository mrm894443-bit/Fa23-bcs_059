import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard.dart';
import 'screens/add_edit_doctor.dart';
import 'screens/add_edit_patient.dart';
import 'screens/doctor_list.dart';
import 'screens/patient_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade700),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/add_doctor': (context) => const AddEditDoctorScreen(),
        '/add_patient': (context) => const AddEditPatientScreen(),
        '/doctors': (context) => const DoctorListScreen(),
        '/patients': (context) => const PatientListScreen(),
      },
    );
  }
}
