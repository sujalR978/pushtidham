class KirtanModel {
  final String id;
  final String number;
  final String title;
  final String imageAsset;
  final String audioAsset;
  bool isFavorite;

  KirtanModel({
    required this.id,
    required this.number,
    required this.title,
    required this.imageAsset,
    required this.audioAsset,
    this.isFavorite = false,
  });

  // Method to convert a KirtanModel to a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'imageAsset': imageAsset,
      'audioAsset': audioAsset,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Factory constructor to create a KirtanModel from a map
  factory KirtanModel.fromMap(Map<String, dynamic> map) {
    return KirtanModel(
      id: map['id'].toString(),
      number: map['number'],
      title: map['title'],
      imageAsset: map['imageAsset'],
      audioAsset: map['audioAsset'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
