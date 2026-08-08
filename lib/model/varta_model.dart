class VartaModel {
  final String id;
  final String number;
  final String titleGujarati;
  final String titleBraj;
  final String shloka;
  final String arth;
  final String vartaContent;
  final String saar;
  bool isFavorite;

  VartaModel({
    required this.id,
    required this.number,
    required this.titleGujarati,
    required this.titleBraj,
    required this.shloka,
    required this.arth,
    required this.vartaContent,
    required this.saar,
    this.isFavorite = false,
  });

  factory VartaModel.fromMap(Map<String, dynamic> map) {
    return VartaModel(
      id: map['id'].toString(),
      number: map['number'],
      titleGujarati: map['titleGujarati'],
      titleBraj: map['titleBraj'],
      shloka: map['shloka'],
      arth: map['arth'],
      vartaContent: map['vartaContent'],
      saar: map['saar'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'titleGujarati': titleGujarati,
      'titleBraj': titleBraj,
      'shloka': shloka,
      'arth': arth,
      'vartaContent': vartaContent,
      'saar': saar,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}
