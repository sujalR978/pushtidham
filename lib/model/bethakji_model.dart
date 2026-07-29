import 'dart:convert';

class BethakjiModel {
  final String id;
  final String number;
  final String name;
  final String address;
  final List<String> contacts;
  final String mahatmy;
  final String directions;
  final List<String> rules;
  final int isFavorite; // 0 = false, 1 = true

  BethakjiModel({
    required this.id,
    required this.number,
    required this.name,
    required this.address,
    required this.contacts,
    required this.mahatmy,
    required this.directions,
    required this.rules,
    this.isFavorite = 0,
  });

  // Copy with method to make toggling local instances clean
  BethakjiModel copyWith({
    String? id,
    String? number,
    String? name,
    String? address,
    List<String>? contacts,
    String? mahatmy,
    String? directions,
    List<String>? rules,
    int? isFavorite,
  }) {
    return BethakjiModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      address: address ?? this.address,
      contacts: contacts ?? this.contacts,
      mahatmy: mahatmy ?? this.mahatmy,
      directions: directions ?? this.directions,
      rules: rules ?? this.rules,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Convert BethakjiModel to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'address': address,
      'contacts': jsonEncode(contacts),
      'mahatmy': mahatmy,
      'directions': directions,
      'rules': jsonEncode(rules),
      'isFavorite': isFavorite,
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
      isFavorite: map['isFavorite'] ?? 0,
    );
  }
}