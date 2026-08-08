class GitaShlokModel {
  final String id;
  final String chapterVerse; // Maps to 'title' in DB or used interchangeably
  final String title;
  final String sanskritShlok; // Maps to 'shlok' in DB
  final String GujaratiArth;  // Maps to 'translation' in DB
  final String tatparya;
  bool isFavorite;

  GitaShlokModel({
    required this.id,
    required this.chapterVerse,
    required this.title,
    required this.sanskritShlok,
    required this.GujaratiArth,
    this.tatparya = '',
    this.isFavorite = false,
  });

  // Convert model to Map for SQLite database insertions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'shlok': sanskritShlok,
      'translation': GujaratiArth,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Convert SQLite Map back to model object (Required by DatabaseHelper)
  factory GitaShlokModel.fromMap(Map<String, dynamic> map) {
    return GitaShlokModel(
      id: map['id']?.toString() ?? '',
      chapterVerse: map['title'] ?? '', // Fallback alignment
      title: map['title'] ?? '',
      sanskritShlok: map['shlok'] ?? '',
      GujaratiArth: map['translation'] ?? '',
      tatparya: '',
      isFavorite: (map['isFavorite'] == 1),
    );
  }
}