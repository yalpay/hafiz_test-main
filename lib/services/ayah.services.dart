import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:flutter/services.dart';
import 'package:hafiz_test/model/aya_model.dart';

Future<AyaModel> getAyaBySurahNo(String surahNameArabic, String ayaNo) async {
  final String response = await rootBundle.loadString('assets/quran.json');
  List<AyaModel> quran = List<AyaModel>.from(
      (json.decode(response)).map((element) => AyaModel.fromJson(element)));
  var x = quran.firstWhere((element) =>
      element.surahNameArabic == surahNameArabic && element.ayahNo == ayaNo);
  return x;
}

class AyahServices {
  final storageServices = StorageServices();
  final favoriteServices = FavouriteServices();
  final allPages = List.generate(600, (index) => index + 1);
  final allJuzs = List.generate(30, (index) => index + 1);

  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    try {
      final res = await rootBundle.loadString('assets/data/surah_data.json');
      final body = json.decode(res);
      final ayahs = Ayah.fromJsonList(body["$surahNumber"]);

      return ayahs;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return [];
    }
  }

  Future<Ayah> getRandomAyahFromJuz(int juzNumber) async {
    final random = Random();
    final favPages = await favoriteServices.getFavoritePages();
    List<int> nonfavPages = allPages
        .where((e) =>
            !favPages.contains(e) &&
            e > (juzNumber - 1) * 20 &&
            e <= juzNumber * 20)
        .toList();
    final page = nonfavPages[random.nextInt(nonfavPages.length)];
    final res = await rootBundle.loadString('assets/data/page_data.json');
    final body = json.decode(res);
    if (body != null) {
      final ayahs = Ayah.fromJsonList(body[page]);
      bool pagetop = await storageServices.checkPageTop();
      if (pagetop) {
        return ayahs.first;
      } else {
        final ayahIndex = random.nextInt(ayahs.length);
        return ayahs[ayahIndex];
      }
    }
    return Ayah();
  }

  Future<int> getRandomJuz() async {
    final favJuzs = await favoriteServices.getFavoriteJuzs();
    List<int> nonFavoriteJuzs =
        allJuzs.where((e) => !favJuzs.contains(e)).toList();
    if (nonFavoriteJuzs.isEmpty) return 1;
    final random = Random();
    final index = random.nextInt(nonFavoriteJuzs.length);
    return nonFavoriteJuzs[index];
  }

  Future<List<Ayah>> getPage(int page) async {
    try {
      final res = await rootBundle.loadString('assets/data/page_data.json');
      final body = json.decode(res);
      final ayahs = Ayah.fromJsonList(body[page]);

      return ayahs;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return [];
    }
  }

  Future<Ayah> getRandomAyahForSurah(List<Ayah> ayahs) async {
    try {
      final random = Random();
      bool pagetopEnabled = await storageServices.checkPageTop();
      final favPages = await favoriteServices.getFavoritePages();

      if (pagetopEnabled) {
        List<int> topPageAyahs = [];
        for (int i = 1; i < ayahs.length; i++) {
          if (ayahs[i].page > ayahs[i - 1].page ||
              favPages.contains(ayahs[i].page) == false) {
            topPageAyahs.add(i);
          }
        }
        if (topPageAyahs.isEmpty) {
          return ayahs[0];
        }
        final index = random.nextInt(topPageAyahs.length);
        return ayahs[topPageAyahs[index]];
      } else {
        List<int> allAyahs = [];
        for (int i = 1; i < ayahs.length; i++) {
          if (favPages.contains(ayahs[i].page) == false) {
            allAyahs.add(i);
          }
        }
        if (allAyahs.isEmpty) {
          return ayahs[0];
        }
        final index = random.nextInt(allAyahs.length - 1);
        return ayahs[allAyahs[index]];
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return Ayah();
  }

//  setState(() {
//         isJuz = true;
//       });
//       verse = widget.verse;
//       var res = await RequestResources().getResources('ayah/$verse/ar.alafasy');
//       var body = json.decode(res.body);
//       setState(() {
//         ayahText = body['data']['text'];
//         ayahAudioUrl = body['data']['audioSecondary'][0];
//         surahNumber = body['data']['surah']['number'];
//       });
//       //For Juz End
}
