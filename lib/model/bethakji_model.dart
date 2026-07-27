

class Bethakji {
  final int? id;
  final int bethakNo;
  final String title;
  final int isFavorite;
  Bethakji({
    this.id,
    required this.bethakNo,
    required this.title,
    this.isFavorite = 0,
  });
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'bethakNo': bethakNo,
      'title': title,
      'isFavorite': isFavorite,
    };
  }
}
