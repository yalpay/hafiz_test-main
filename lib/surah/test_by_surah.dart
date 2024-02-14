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
  bool autoplay = true;
  late Surah surah;
  late Ayah ayah;

  int surahNumber = 1;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    setState(() => isLoading = true);

    surahNumber = widget.surahNumber;
    surah = await surahServices.getSurah(surahNumber);
    ayah = await ayahServices.getRandomAyahForSurah(surah.ayahs);

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
          key: UniqueKey(),
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
                  onRefresh: () async => await init(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
