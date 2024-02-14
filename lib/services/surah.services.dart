import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:hafiz_test/model/ayah.model.dart';

import 'package:hafiz_test/model/surah.model.dart';

class SurahServices {
  int getRandomSurahNumber() {
    final surahNumber = 1 + Random().nextInt(111); // skip the last easy surahs

    return surahNumber;
  }

  Future<Surah> getSurah(int surahNumber) async {
    String res = await rootBundle.loadString('assets/data/surah_data.json');
    Map<String, dynamic> json = jsonDecode(res);
    final ayahs = Ayah.fromJsonList(json["$surahNumber"]);
    Surah surah = Surah(ayahs);
    return surah;
  }
}
