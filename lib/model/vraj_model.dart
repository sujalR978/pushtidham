class VrajbhashaModel {
  final String id;
  final String number;
  final String title;
  final String padText;     // The main Vrajbhasha poetry/kirtan
  final String bhavarth;    // The meaning or translation
  final String prasang;     // Context or background story (optional)
  bool isFavorite;

  VrajbhashaModel({
    required this.id,
    required this.number,
    required this.title,
    required this.padText,
    required this.bhavarth,
    this.prasang = '',
    this.isFavorite = false,
  });

  // 1. Convert model to Map for database insertions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'padText': padText,
      'bhavarth': bhavarth,
      'prasang': prasang,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // 2. Convert SQLite Map back to model object (Fixes DatabaseHelper errors)
  factory VrajbhashaModel.fromMap(Map<String, dynamic> map) {
    return VrajbhashaModel(
      id: map['id']?.toString() ?? '',
      number: map['number'] ?? '',
      title: map['title'] ?? '',
      padText: map['padText'] ?? '',
      bhavarth: map['bhavarth'] ?? '',
      prasang: map['prasang'] ?? '',
      isFavorite: (map['isFavorite'] == 1),
    );
  }
}