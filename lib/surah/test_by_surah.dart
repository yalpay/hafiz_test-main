import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:hafiz_test/page/test_screen.dart';

class TestBySurah extends StatefulWidget {
  final int surahNumber;

  const TestBySurah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestBySurah> {
  final surahServices = SurahServices();
  final ayahServices = AyahServices();

  bool isLoading = false;
  bool isPlaying = false;

  List<Ayah> ayahs = [];
  late Ayah ayah;

  int surahNumber = 1;

  @override
  void initState() {
    super.initState();

    init();
  }

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    surahNumber = widget.surahNumber;
    surah = await surahServices.getSurah(surahNumber);
    ayahs = surah.ayahs;
    ayah = await ayahServices.getRandomAyahForSurah(ayahs);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sure Listesi'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 5,
                    backgroundColor: Colors.blueGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                TestScreen(
                  surah: surah,
                  ayah: ayah,
                  ayahs: ayahs,
                  onRefresh: () async => await init(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
