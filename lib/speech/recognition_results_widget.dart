import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: Center(
                  child: Text(
                    speechProvider.lastResult?.recognizedWords ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
