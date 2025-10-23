import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
// file_picker is not currently used; keep commented in case needed later
// import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final Directory appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);
  }
  await Hive.openBox('students');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhail Saeed Card App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00796B),
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const StudentHomePage(),
    );
  }
}

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final Box studentsBox = Hive.box('students');
  final Uuid _uuid = const Uuid();

  Future<void> _openStudentDialog({Map<String, dynamic>? student}) async {
    final nameCtrl = TextEditingController(text: student?['name'] ?? '');
    final rollCtrl = TextEditingController(text: student?['roll'] ?? '');
    final deptCtrl = TextEditingController(text: student?['department'] ?? '');
    String? imagePath = student?['imagePath'];
    String? imageDataUrl = student?['imageDataUrl'];

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          final base64Str = base64Encode(bytes);
          imageDataUrl =
              'data:image/${file.name.split('.').last};base64,$base64Str';
          imagePath = null;
        } else {
          imagePath = file.path;
          imageDataUrl = null;
        }
        setState(() {});
      }
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      student == null ? 'Add Student' : 'Edit Student',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF26A69A), Color(0xFF00796B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (imageDataUrl != null)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageDataUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (imagePath != null &&
                            imagePath!.isNotEmpty &&
                            !kIsWeb)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(height: 8),
                              Text(
                                'Tap to pick from gallery',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: rollCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Roll Number',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final roll = rollCtrl.text.trim();
                    final dept = deptCtrl.text.trim();
                    if (name.isEmpty || roll.isEmpty || dept.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    final id = student?['id'] ?? _uuid.v4();
                    final data = {
                      'id': id,
                      'name': name,
                      'roll': roll,
                      'department': dept,
                      'imagePath': imagePath,
                      'imageDataUrl': imageDataUrl,
                      'createdAt': DateTime.now().toIso8601String(),
                    };
                    await studentsBox.put(id, data);
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: Text(
                    student == null ? 'Save Student' : 'Update Student',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteStudent(String id) async => await studentsBox.delete(id);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0F7FA), // light aqua
            Color(0xFFB2EBF2), // soft cyan
            Color(0xFF80CBC4), // mint green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00796B), // deep teal
                  Color(0xFF26A69A), // medium teal
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Text('Minhail Saeed Card App'),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: studentsBox.listenable(),
          builder: (_, Box box, __) {
            final students =
                box.values
                    .cast<Map>()
                    .map((e) => e.cast<String, dynamic>())
                    .toList()
                  ..sort(
                    (a, b) =>
                        (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''),
                  );
            if (students.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.contact_page, size: 64, color: Colors.black54),
                    SizedBox(height: 12),
                    Text('No students yet. Tap + to add.'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: students.length,
              itemBuilder: (_, i) {
                final s = students[i];
                return _StudentCard(
                  student: s,
                  onEdit: () => _openStudentDialog(student: s),
                  onDelete: () => _deleteStudent(s['id']),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openStudentDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _StudentCard({
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = student['imagePath'] as String?;
    final imageDataUrl = student['imageDataUrl'] as String?;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: SizedBox(
                width: 52,
                height: 52,
                child: (imageDataUrl != null && imageDataUrl.isNotEmpty)
                    ? Image.network(imageDataUrl, fit: BoxFit.cover)
                    : (imagePath != null && imagePath.isNotEmpty && !kIsWeb)
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : const Icon(Icons.person, color: Colors.black54),
              ),
            ),
          ),
          title: Text(
            student['name'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Roll: ${student['roll']}  •  Dept: ${student['department']}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Color(0xFF00796B)),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Color(0xFFB71C1C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
