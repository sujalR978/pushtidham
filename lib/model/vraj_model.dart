class VrajbhashaModel {
  final String id;
  final String number;
  final String title;
  final String padText; // The main Vrajbhasha poetry/kirtan
  final String bhavarth; // The meaning or translation
  final String prasang; // Context or background story (optional)
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
}
