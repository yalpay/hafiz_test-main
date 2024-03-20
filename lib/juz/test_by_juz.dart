import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafiz_test/data/surah_list.dart';
import 'package:hafiz_test/page/test_screen.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';

class TestByJuz extends StatefulWidget {
  final int juzNumber;
  final String title;

  const TestByJuz({Key? key, required this.juzNumber, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestByJuz> {
  bool isLoading = false;

  late Ayah ayah;
  int juzNumber = 0;
  bool autoplay = true;
  late Surah surah;

  Future<void> init() async {
    setState(() => isLoading = true);

    final ayahServices = AyahServices();
    juzNumber = widget.juzNumber;

    if (juzNumber == 0) {
      juzNumber = await ayahServices.getRandomJuz();
    }
    ayah = await ayahServices.getRandomAyahFromJuz(juzNumber);
    int surahIndex = surahs.indexOf(ayah.surah);
    surah = await SurahServices().getSurah(surahIndex + 1);

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                )
            ],
          ),
        ),
      ),
    );
  }
}
