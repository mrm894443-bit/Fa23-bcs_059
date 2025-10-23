import 'package:flutter/material.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  String selectedSkillLevel = "Intermediate"; // Dropdown default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 AppBar color change
      appBar: AppBar(
        title: const Text("Resume"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        elevation: 5,
      ),

      // 🔹 Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF), Color(0xFFE0F2F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Profile Section with CircleAvatar
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Minahil Saeed",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const Text(
                "Flutter Developer",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),

              const SizedBox(height: 20),
              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Contact Info
              Card(
                color: Colors.teal.shade50,
                child: const ListTile(
                  leading: Icon(Icons.email, color: Colors.teal),
                  title: Text("minahilsaeed@gmail.com"),
                ),
              ),
              Card(
                color: Colors.teal.shade50,
                child: const ListTile(
                  leading: Icon(Icons.phone, color: Colors.teal),
                  title: Text("0344-3317788"),
                ),
              ),
              Card(
                color: Colors.teal.shade50,
                child: const ListTile(
                  leading: Icon(Icons.location_on, color: Colors.teal),
                  title: Text("Vehari, Pakistan"),
                ),
              ),

              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Education
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Education",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
              Card(
                color: Colors.blue.shade50,
                child: const ListTile(
                  leading: Icon(Icons.school, color: Colors.teal),
                  title: Text("BS Computer Science"),
                  subtitle: Text("COMSAT University Islamabad, Vehari Campus"),
                  trailing: Text("2023  -  2027"),
                ),
              ),

              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Skills with DropdownButton
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Skills",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
              Row(
                children: [
                  const Text("Flutter: ",
                      style: TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: selectedSkillLevel,
                    dropdownColor: Colors.teal.shade50,
                    items: const [
                      DropdownMenuItem(
                          value: "Beginner", child: Text("Beginner")),
                      DropdownMenuItem(
                          value: "Intermediate", child: Text("Intermediate")),
                      DropdownMenuItem(value: "Expert", child: Text("Expert")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSkillLevel = value!;
                      });
                    },
                  ),
                ],
              ),

              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Experience
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Experience",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
              Card(
                color: Colors.orange.shade50,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const ListTile(
                  leading: Icon(Icons.work, color: Colors.teal),
                  title: Text("Flutter Intern"),
                  subtitle: Text("YIR Systems  -  2025"),
                ),
              ),

              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Projects
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Projects",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
              Card(
                color: Colors.purple.shade50,
                child: ListTile(
                  title: const Text("Online Coffee Order App"),
                  subtitle: const Text("Built with Flutter"),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text("View"),
                  ),
                ),
              ),
              Card(
                color: Colors.purple.shade50,
                child: ListTile(
                  title: const Text("Several Login Pages"),
                  subtitle: const Text("Built with Flutter"),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text("View"),
                  ),
                ),
              ),

              Divider(thickness: 2, color: Colors.teal.shade200),

              // 🔹 Download CV button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text("Download CV"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
