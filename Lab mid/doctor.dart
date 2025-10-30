class Doctor {
  int? id;
  String name;
  String? specialization;
  String? phone;

  Doctor({this.id, required this.name, this.specialization, this.phone});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'specialization': specialization,
      'phone': phone,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as int?,
      name: map['name'] as String,
      specialization: map['specialization'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
