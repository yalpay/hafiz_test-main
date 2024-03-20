import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class RepeatScreen extends StatefulWidget {
  const RepeatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<RepeatScreen> {
  SpeechToText speechToText = SpeechToText();
  String recognizedWords = "";
  String text = "This is the text to be repeated";
  int correctIndex = 0;
  bool isListening = false;

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

  @override
  void initState() {
    super.initState();

    checkMicrophoneAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(text),
        const SizedBox(height: 20),
        Text(recognizedWords),
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
                  await speechToText.listen(
                      listenFor: const Duration(minutes: 1),
                      onResult: (result) {
                        setState(() {
                          recognizedWords = result.recognizedWords;
                          for (var i = 0;
                              i < text.length && i < recognizedWords.length;
                              i++) {
                            if (text[i] != recognizedWords[i]) {
                              correctIndex = i;
                              _showDialog(
                                  "from here the text is different: $i character");
                              break;
                            }
                          }
                        });
                      });
                  setState(() {
                    isListening = false;
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
        ),
      ],
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
