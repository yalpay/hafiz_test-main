import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage.services.dart';

class AyahServices {
  final _networkServices = NetworkServices();
  final storageServices = StorageServices();

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

  Future<List<Ayah>> getRandomPage() async {
    final random = Random();
    final page = random.nextInt(600);
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
      final pagetop = await storageServices.checkPageTop();
      if (pagetop == true) {
        List<int> topPageAyahs = [];
        for (int i = 1; i < ayahs.length; i++) {
          if (ayahs[i].page > ayahs[i - 1].page) {
            topPageAyahs.add(i);
          }
        }
        if (topPageAyahs.isEmpty) {
          return ayahs[0];
        }
        final index = random.nextInt(topPageAyahs.length);
        return ayahs[topPageAyahs[index]];
      } else {
        final range = random.nextInt(ayahs.length - 1);
        return ayahs[range];
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
