import 'dart:convert';

class BethakjiModel {
  final String id;
  final String number;
  final String name;
  final String address;
  final List<String> contacts; // or List<Map<String, String>>
  final String mahatmy;
  final String directions;
  final List<String> rules;

  BethakjiModel({
    required this.id,
    required this.number,
    required this.name,
    required this.address,
    required this.contacts,
    required this.mahatmy,
    required this.directions,
    required this.rules,
  });

  // Convert BethakjiModel to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'address': address,
      // Serialize lists/maps to String JSON format
      'contacts': jsonEncode(contacts),
      'mahatmy': mahatmy,
      'directions': directions,
      'rules': jsonEncode(rules),
    };
  }

  // Read Map from SQLite back to BethakjiModel
  factory BethakjiModel.fromMap(Map<String, dynamic> map) {
    return BethakjiModel(
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      contacts: List<String>.from(jsonDecode(map['contacts'] ?? '[]')),
      mahatmy: map['mahatmy'] ?? '',
      directions: map['directions'] ?? '',
      rules: List<String>.from(jsonDecode(map['rules'] ?? '[]')),
    );
  }
}