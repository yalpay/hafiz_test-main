import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/page/view_full_page.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/util/util.dart';
import 'package:hafiz_test/widget/button.dart';
import 'package:hafiz_test/data/surah_list.dart';

class PageTestScreen extends StatefulWidget {
  final Surah surah;
  final Ayah ayah;
  final List<Ayah> ayahs;
  final List<Ayah> page;
  final Function()? onRefresh;

  const PageTestScreen({
    Key? key,
    required this.surah,
    required this.ayah,
    this.ayahs = const [],
    required this.page,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<PageTestScreen> {
  final audioPlayer = AudioPlayer();
  final storageServices = StorageServices();

  Surah surah = Surah();
  List<Ayah> ayahs = [];
  Ayah ayah = Ayah();

  bool isPlaying = false;
  bool autoplay = true;

  Future<void> init() async {
    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.ayahs;

    autoplay = await storageServices.checkAutoPlay();

    handleAudioPlay();
  }

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));
    } catch (e) {
      setState(() => isPlaying = false);
    }
  }

  Future<void> playNextAyah() async {
    if (ayah.numberInSurah >= ayahs.length) {
      showSnackBar(context, 'Sure Sonu');

      return;
    }

    ayah = ayahs[ayah.numberInSurah];

    handleAudioPlay();
  }

  Future<void> playPreviousAyah() async {
    if (ayah.numberInSurah == 1) {
      showSnackBar(context, 'Sure Başı');

      return;
    }

    ayah = ayahs[ayah.numberInSurah - 2];

    handleAudioPlay();
  }

  void handleAudioPlay() {
    if (mounted) {
      if (autoplay) {
        setState(() => isPlaying = true);
        playAudio(ayah.audio);
      } else {
        audioPlayer.pause();
        setState(() => isPlaying = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    init();

    audioPlayer.onPlayerComplete.listen((_) async {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  dispose() {
    audioPlayer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            if (ayah.numberInSurah < ayahs.length)
              const Text(
                'Bir Sonraki Ayete Geç!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                ),
              ).animate(
                onPlay: (controller) {
                  controller.repeat(reverse: true);
                },
              ).scaleXY(end: 1.5, delay: 1000.ms),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                ayah.text.length > 400
                    ? ayah.text.substring(0, 400)
                    : ayah.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: surahs[surah.number - 1],
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  TextSpan(
                    text: ' - ${ayah.numberInSurah}.Ayet',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(${surah.name})',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 80.0,
                color: Colors.blueGrey,
              ),
              onTap: () {
                isPlaying ? audioPlayer.pause() : playAudio(ayah.audio);

                isPlaying = !isPlaying;

                setState(() {});
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: const Text(
                      'Önceki Ayet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => playPreviousAyah(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    iconPosition: IconPosition.right,
                    text: const Text(
                      'Sonraki Ayet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => playNextAyah(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomButton(
              width: 300,
              text: const Text(
                'Tüm Sayfayı Görüntüle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return PageScreen(
                        page: widget.page,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              width: 300,
              text: const Text(
                'Yeniden Sor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                await widget.onRefresh?.call();
                init();
              },
            ),
          ],
        ),
      ),
    );
  }
}
