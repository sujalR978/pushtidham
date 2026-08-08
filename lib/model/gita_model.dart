class GitaShlokModel {
  final String id;
  final String chapterVerse; // e.g., "૨.૪૭" or "Chapter 2, Verse 47"
  final String title;        // e.g., "કર્મણ્યેવાધિકારસ્તે"
  final String sanskritShlok;// The Sanskrit shlok text
  final String GujaratiArth; // Meaning in Gujarati
  final String tatparya;     // Deeper commentary / Tatparya (Optional)

  GitaShlokModel({
    required this.id,
    required this.chapterVerse,
    required this.title,
    required this.sanskritShlok,
    required this.GujaratiArth,
    this.tatparya = '',
  });
}