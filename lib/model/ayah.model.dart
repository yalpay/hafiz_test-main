class Ayah {
  final int number;
  final String surah;
  final int numberInSurah;
  final int juz;
  final String originalText;
  final int page;
  final String arabicText;
  final int arabicLetterCount;
  final int arabicWordCount;

  Ayah({
    this.number = 0,
    this.surah = '',
    this.arabicText = '',
    this.originalText = '',
    this.numberInSurah = 0,
    this.juz = 0,
    this.arabicLetterCount = 0,
    this.page = 0,
    this.arabicWordCount = 0,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: int.parse(json['number']),
      surah: json['surah'],
      arabicText: json['arabicText'],
      numberInSurah: int.parse(json['numberInSurah']),
      juz: int.parse(json['juz']),
      originalText: json['originalText'],
      page: int.parse(json['page']),
      arabicLetterCount: int.parse(json['arabicLetterCount']),
      arabicWordCount: int.parse(json['arabicWordCount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'arabicText': arabicText,
      'originalText': originalText,
      'arabicLetterCount': arabicLetterCount,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'arabicWordCount': arabicWordCount,
      'page': page,
      'surah': surah,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static List<Ayah> fromJsonList(List jsonList) {
    return jsonList.map((json) => Ayah.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Ayah> ayahList) {
    return ayahList.map((ayah) => ayah.toJson()).toList();
  }
}
