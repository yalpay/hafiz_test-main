import 'package:flutter/material.dart';
import 'package:hafiz_test/services/storage.services.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  bool autoPlay = true;
  bool pageTop = false;
  double speed = 0;
  bool isLoading = true;
  final storageServices = StorageServices();

  Future<void> init() async {
    autoPlay = await storageServices.checkAutoPlay();
    pageTop = await storageServices.checkPageTop();
    speed = double.parse(await storageServices.getPlaybackSpeed());

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Ayarlar',
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ayeti otomatik yürüt',
                      style: TextStyle(fontSize: 12),
                    ),
                    Switch(
                      value: autoPlay,
                      onChanged: (_) {
                        setState(() => autoPlay = !autoPlay);
                      },
                      activeTrackColor: Colors.blueGrey,
                      activeColor: Colors.green,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ayetler Sayfa Başından Olsun',
                      style: TextStyle(fontSize: 12),
                    ),
                    Switch(
                      value: pageTop,
                      onChanged: (_) {
                        setState(() => pageTop = !pageTop);
                      },
                      activeTrackColor: Colors.blueGrey,
                      activeColor: Colors.green,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ses Hızı',
                      style: TextStyle(fontSize: 12),
                    ),
                    Slider(
                      value: speed,
                      min: 0.5,
                      max: 2,
                      divisions: 6,
                      label: '$speed',
                      onChanged: (value) {
                        setState(() {
                          speed = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            storageServices.setAutoPlay(autoPlay.toString());
            storageServices.setPageTop(pageTop.toString());
            storageServices.setPlaybackSpeed(speed.toString());
            Navigator.of(context).pop(true);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
