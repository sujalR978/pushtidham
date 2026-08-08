class KirtanModel {
  final String id;
  final String number;
  final String title;
  final String imageAsset;
  final String audioAsset; // Changed from audioUrl to audioAsset

  KirtanModel({
    required this.id,
    required this.number,
    required this.title,
    required this.imageAsset,
    required this.audioAsset, // Require it in the constructor
  });
}
