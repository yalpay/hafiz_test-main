import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:intl/intl.dart' hide TextDirection;

class PageScreen extends StatefulWidget {
  final List<Ayah> page;

  const PageScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<PageScreen> {
  bool isLoading = false;
  bool isPlaying = false;

  List<Ayah> page = [];

  void getSurah() {
    setState(() => isLoading = true);

    page = widget.page;

    setState(() => isLoading = false);
  }

  final audioPlayer = AudioPlayer();

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));

      setState(() => isPlaying = true);
    } catch (e) {
      setState(() => isPlaying = false);
    }
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    getSurah();

    audioPlayer.onPlayerComplete.listen((_) async {
      setState(() {
        isPlaying = false;
      });
    });
  }

  String makeAyahNumber(int ayahNumber) {
    final formatedAyahNumber = NumberFormat('#', 'ar_EG').format(ayahNumber);
    final runes = Runes('   \u{fd3f}$formatedAyahNumber\u{fd3e}');

    return String.fromCharCodes(runes);
  }

  String getPageHeader(Ayah ayah) {
    int donus = 21 - (ayah.page % 20);
    return "${ayah.juz.toString()}.Cüz ${(donus == 21 ? 1 : donus).toString()}.Dönüş";
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getPageHeader(page.first),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading)
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              else
                Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: page.length,
                      itemBuilder: (context, index) {
                        final ayah = page[index];

                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // if (index == selectedIndex)
                                //   if (isPlaying)
                                //     const Icon(
                                //       Icons.volume_up,
                                //       color: Colors.blueGrey,
                                //     ).animate(
                                //       onPlay: (controller) {
                                //         controller.repeat(reverse: true);
                                //       },
                                //     ).scaleXY()
                                //   else
                                //     const Icon(
                                //       Icons.volume_up,
                                //       color: Colors.blueGrey,
                                //     ),
                                Expanded(
                                  child: Text.rich(
                                    textDirection: TextDirection.rtl,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: ayah.text,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                            fontFamily: 'Quran',
                                          ),
                                        ),
                                        TextSpan(
                                          text: makeAyahNumber(
                                              ayah.numberInSurah),
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Quran',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onLongPress: () async {
                            setState(() => selectedIndex = index);
                            await audioPlayer.pause();
                            await playAudio(ayah.audio);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(color: Colors.black);
                      },
                    ),
                    const Divider(color: Colors.black),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
