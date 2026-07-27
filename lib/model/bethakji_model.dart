import 'dart:convert';

class BethakjiModel {
  final String id;
  final String number;
  final String name;
  final String address;
  final List<Map<String, String>> contacts;
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

  factory BethakjiModel.fromMap(Map<String, dynamic> map) {
    return BethakjiModel(
      id: map['id'].toString(),
      number: map['number'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      // Decode JSON string back to List<Map<String, String>>
      contacts: map['contacts'] != null
          ? List<Map<String, String>>.from(
              (jsonDecode(map['contacts']) as List).map(
                (item) => Map<String, String>.from(item),
              ),
            )
          : [],
      mahatmy: map['mahatmy'] ?? '',
      directions: map['directions'] ?? '',
      // Decode JSON string back to List<String>
      rules: map['rules'] != null
          ? List<String>.from(jsonDecode(map['rules']))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'address': address,
      // Encode lists/maps as JSON strings for SQLite
      'contacts': contacts,
      'mahatmy': mahatmy,
      'directions': directions,
      'rules': jsonEncode(rules),
    };
  }
}