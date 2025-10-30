class Patient {
  int? id;
  String name;
  int? age;
  String? address;
  String? phone;

  Patient({this.id, required this.name, this.age, this.address, this.phone});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'age': age,
      'address': address,
      'phone': phone,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int?,
      address: map['address'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
