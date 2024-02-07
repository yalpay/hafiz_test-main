import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage.services.dart';

class AyahServices {
  final _networkServices = NetworkServices();
  final storageServices = StorageServices();
  final favoriteServices = FavouriteServices();
  final allPages = List.generate(600, (index) => index + 1);
  final allJuzs = List.generate(30, (index) => index + 1);

  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    try {
      final res = await _networkServices.get('surah/$surahNumber/ar.alafasy');

      final body = json.decode(res.body);

      final ayahs = Ayah.fromJsonList(body['data']['ayahs']);

      return ayahs;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return [];
    }
  }

  Future<Ayah> getRandomAyahFromJuz(int juzNumber) async {
    final pagetop = await storageServices.checkPageTop();
    if (pagetop) {
      final random = Random();
      final page = (juzNumber - 1) * 20 + random.nextInt(20);
      final res = await _networkServices.get('page/$page/quran-uthmani');
      final body = json.decode(res.body);
      if (body != null) {
        final ayahs = Ayah.fromJsonList(body['data']['ayahs']);
        return ayahs.first;
      }
    } else {
      final res = await _networkServices.get('juz/$juzNumber/quran-uthmani');
      final body = json.decode(res.body);

      if (body != null) {
        final ayahs = Ayah.fromJsonList(body['data']['ayahs']);
        final ayah = AyahServices().getRandomAyahForSurah(ayahs);

        return ayah;
      }
    }

    return Ayah();
  }

  Future<int> getRandomJuz() async {
    final favJuzs = await favoriteServices.getFavoriteJuzs();
    List<int> nonFavoriteJuzs =
        allJuzs.where((e) => !favJuzs.contains(e)).toList();
    final random = Random();
    final index = random.nextInt(nonFavoriteJuzs.length);
    return nonFavoriteJuzs[index];
  }

  Future<List<Ayah>> getPage(int? page) async {
    if (page == null) {
      final favPages = await favoriteServices.getFavoritePages();
      List<int> nonFavoritePages =
          allPages.where((e) => !favPages.contains(e)).toList();
      final random = Random();
      final index = random.nextInt(nonFavoritePages.length);
      page = nonFavoritePages[index];
    }

    final res = await _networkServices.get('page/$page/quran-uthmani');
    final body = json.decode(res.body);

    if (body != null) {
      final ayahs = Ayah.fromJsonList(body['data']['ayahs']);
      return ayahs;
    }

    return [];
  }

  Future<Ayah> getRandomAyahForSurah(List<Ayah> ayahs) async {
    try {
      final random = Random();
      final pagetopEnabled = await storageServices.checkPageTop();
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
