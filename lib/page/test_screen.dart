import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/page/arabic_spec.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:hafiz_test/page/view_full_page.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/ui/snack_bar.dart';
import 'package:hafiz_test/ui/button.dart';
import 'package:hafiz_test/data/surah_list.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TestScreen extends StatefulWidget {
  final Surah surah;
  final Ayah ayah;
  final Function() onRefresh;

  const TestScreen({
    Key? key,
    required this.surah,
    required this.ayah,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestScreen> {
  final audioPlayer = AudioPlayer();
  final storageServices = StorageServices();
  final audioSource = "https://cdn.islamic.network/quran/audio/128/ar.alafasy/";
  final maxAyahLength = 350;
  late Surah surah;
  List<Ayah> ayahs = [];
  Ayah ayah = Ayah();
  String audioUrl = "";
  bool isPlaying = false;
  bool autoplay = true;
  String text = "";
  bool isReadingCorrect = false;
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastStatus = '';
  final String _currentLocaleId = 'ar_SA';
  final SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize();

      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        _hasSpeech = false;
      });
    }
  }

  Future<void> init() async {
    initSpeechState();

    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.surah.ayahs;
    autoplay = await storageServices.checkAutoPlay();
    handleAudioPlay();
  }

  Future<void> playAudio(String url) async {
    if (mounted) {
      try {
        final speed = await storageServices.getPlaybackSpeed();
        await audioPlayer.play(UrlSource(url));
        audioPlayer.setPlaybackRate(double.parse(speed));
      } catch (e) {
        setState(() => isPlaying = false);
      }
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
        setState(() {
          isPlaying = true;
          text = "";
        });
        audioUrl = "${audioSource + ayah.number.toString()}.mp3";
        playAudio(audioUrl);
      } else {
        audioPlayer.pause();
        setState(() {
          isPlaying = false;
          text = "";
        });
      }
    }
  }

  void startListening() {
    if (!mounted) return;
    text = '';
    final options = SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 70),
      pauseFor: const Duration(seconds: 4),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      text = result.recognizedWords;
      isReadingCorrect =
          areStringsEqual(ayahs[ayah.numberInSurah].arabicText, text);
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
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
    return Column(
      children: [
        if (ayah.numberInSurah < ayahs.length)
          const Text(
            'Bir Sonraki Ayete Geç!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 20,
            ),
          ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            ayah.originalText.length > maxAyahLength
                ? ayah.originalText.substring(0, maxAyahLength)
                : ayah.originalText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.blueGrey,
            ),
          ),
        ),
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
        if (text.isNotEmpty && isReadingCorrect)
          const Icon(
            Icons.check,
            size: 50.0,
            color: Colors.green,
          ),
        if (speech.isListening == false &&
            text.isNotEmpty &&
            isReadingCorrect == false)
          SelectableText(
              "Ayet:${ayahs[ayah.numberInSurah].arabicText}\nOkuyuşunuz:$text"),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        if (speech.isListening == false)
          InkWell(
            child: Icon(
              isPlaying
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
              size: 80.0,
              color: Colors.blueGrey,
            ),
            onTap: () {
              isPlaying ? audioPlayer.pause() : playAudio(audioUrl);

              isPlaying = !isPlaying;

              setState(() {});
            },
          ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 20),
        CustomButton(
          width: 300,
          text: const Text(
            'Sayfayı Görüntüle',
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
                  return PageScreen(ayah: ayah);
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
            await widget.onRefresh.call();
            await init();
          },
        ),
        const SizedBox(height: 10),
        SpeechControlWidget(_hasSpeech, speech.isListening, startListening),
        SpeechStatusWidget(speech: speech),
      ],
    );
  }
}

class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(
      this.hasSpeech, this.isListening, this.startListening,
      {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: const CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.mic,
            ),
          ),
        ),
      ],
    );
  }
}

class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child:
            speech.isListening ? const Text("Dinliyor..") : const Text("Kayıt"),
      ),
    );
  }
}
