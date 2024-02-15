import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/page/view_full_page.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/widgets/snack_bar.dart';
import 'package:hafiz_test/widgets/button.dart';
import 'package:hafiz_test/data/surah_list.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

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
  SpeechToText speechToText = SpeechToText();
  final storageServices = StorageServices();
  final auidoUrl = "https://cdn.islamic.network/quran/audio/128/ar.alafasy/";
  var isListening = false;
  final maxAyahLength = 350;
  late Surah surah;
  List<Ayah> ayahs = [];
  Ayah ayah = Ayah();
  String audioUrl = "";
  bool isPlaying = false;
  bool autoplay = true;
  String text = "Recognized words";

  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        if (kDebugMode) {
          print('Microphone available: $available');
        }
      });
    } else {
      if (kDebugMode) {
        print("The user has denied the use of speech recognition.");
      }
    }
  }

  Future<void> init() async {
    checkMicrophoneAvailability();

    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.surah.ayahs;
    audioUrl = "${auidoUrl + ayah.number.toString()}.mp3";
    autoplay = await storageServices.checkAutoPlay();
    text = ayah.arabicText;

    handleAudioPlay();
  }

  Future<void> playAudio(String url) async {
    try {
      final speed = await storageServices.getPlaybackSpeed();
      await audioPlayer.play(UrlSource(url));
      audioPlayer.setPlaybackRate(double.parse(speed));
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
        playAudio(audioUrl);
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 20),
        if (isListening == false)
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
        const SizedBox(height: 15),
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
        if (isPlaying == false)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SelectableText(
              "Okumaya başlamak için dokun",
              style: TextStyle(
                  fontSize: 18,
                  color: isListening ? Colors.black87 : Colors.black54),
            ),
          ),
        if (isPlaying == false)
          AvatarGlow(
            animate: isListening,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: GestureDetector(
              onTap: () async {
                if (!isListening) {
                  var available = await speechToText.initialize();
                  if (available) {
                    setState(() {
                      isListening = true;
                    });
                    speechToText.listen(
                        listenFor: const Duration(days: 1),
                        onResult: (result) {
                          setState(() {
                            text = result.recognizedWords;
                          });
                        });
                  }
                } else {
                  setState(() {
                    isListening = false;
                  });
                  speechToText.stop();
                }
              },
              child: CircleAvatar(
                radius: 30,
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_off,
                  color: Colors.red,
                ),
              ),
            ),
          )
      ],
    );
  }
}
