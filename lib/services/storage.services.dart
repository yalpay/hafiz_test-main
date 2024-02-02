import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class Setting {
  @HiveField(0)
  bool settingValue;

  Setting({required this.settingValue});
}

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  int get typeId => 0;

  @override
  Setting read(BinaryReader reader) {
    return Setting(
      settingValue: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer.write(obj.settingValue);
  }
}

class StorageServices {
  Box<Setting>? settingsBox;

  StorageServices() {
    settingsBox = Hive.box<Setting>('settings');
  }

  Future<bool> checkAutoPlay() async {
    if (settingsBox == null || settingsBox!.get("autoplay") == null) {
      return true;
    }
    return settingsBox!.get("autoplay")!.settingValue;
  }

  Future<void> setAutoPlay(bool autoPlay) async {
    Hive.box<Setting>('settings')
        .put("autoplay", Setting(settingValue: autoPlay));
  }

  Future<bool> checkPageTop() async {
    if (settingsBox == null || settingsBox!.get("pagetop") == null) {
      return true;
    }
    return settingsBox!.get("pagetop")!.settingValue;
  }

  Future<void> setPageTop(bool pageTop) async {
    Hive.box<Setting>('settings')
        .put("pagetop", Setting(settingValue: pageTop));
  }
}
