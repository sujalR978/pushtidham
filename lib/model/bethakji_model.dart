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
      id: map['id']?.toString() ?? '', // Safe conversion from int or String
      number: map['number']?.toString() ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      contacts: _parseList(map['contacts']),
      mahatmy: map['mahatmy'] ?? '',
      directions: map['directions'] ?? '',
      rules: _parseList(map['rules']),
      isFavorite: map['isFavorite'] is int ? map['isFavorite'] : 0,
    );
  }

  // Helper method to safely parse List<String> from JSON string or raw List
  static List<String> _parseList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData.map((e) => e.toString()).toList();
    if (rawData is String) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        return [];
      }
    }
    return [];
  }
}
