import 'package:hafiz_test/data/surah_list.dart';
import 'package:hafiz_test/model/ayah.model.dart';

class Surah {
  final int number;
  final String name;
  final List<Ayah> ayahs;

  Surah(this.ayahs)
      : assert(ayahs.isNotEmpty),
        number = surahs.indexOf(ayahs.first.surah) + 1,
        name = ayahs.first.surah;
}
