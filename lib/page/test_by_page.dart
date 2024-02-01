import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/page/test_screen.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';

class TestByPage extends StatefulWidget {
  const TestByPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestByPage> {
  bool isLoading = false;

  List<Ayah> ayahs = [];
  List<Ayah> page = [];

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    page = await AyahServices().getRandomPage();
    surah = await SurahServices().getSurah(page.first.surah!.number);
    ayahs = surah.ayahs;

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
        title: const Text('Ana Sayfa'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
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
            PageTestScreen(
              surah: surah,
              ayah: page.first,
              ayahs: ayahs,
              page: page,
              onRefresh: () async => await init(),
            ),
        ],
      ),
    );
  }
}
