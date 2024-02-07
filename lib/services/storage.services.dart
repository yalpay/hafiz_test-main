import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class Setting {
  @HiveField(0)
  String settingValue;

  Setting({required this.settingValue});
}

@HiveType(typeId: 1)
class Favourite {
  @HiveField(0)
  List<int> favorites;

  Favourite({required this.favorites});
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

class FavouriteAdapter extends TypeAdapter<Favourite> {
  @override
  int get typeId => 1;

  @override
  Favourite read(BinaryReader reader) {
    return Favourite(
      favorites: reader.readList().cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Favourite obj) {
    writer.writeList(obj.favorites);
  }
}

class StorageServices {
  Box<Setting>? settingsBox;

  StorageServices() {
    settingsBox = Hive.box<Setting>('setting');
  }

  Future<bool> checkAutoPlay() async {
    if (settingsBox == null || settingsBox!.get("autoplay") == null) {
      return true;
    }
    return settingsBox!.get("autoplay")!.settingValue == "true";
  }

  Future<void> setAutoPlay(String autoPlay) async {
    settingsBox!.put("autoplay", Setting(settingValue: autoPlay));
  }

  Future<String> getPlaybackSpeed() async {
    if (settingsBox == null || settingsBox!.get("speed") == null) {
      return "1";
    }
    return settingsBox!.get("speed")!.settingValue;
  }

  Future<void> setPlaybackSpeed(String speed) async {
    settingsBox!.put("speed", Setting(settingValue: speed));
  }

  Future<bool> checkPageTop() async {
    if (settingsBox == null || settingsBox!.get("pagetop") == null) {
      return true;
    }
    return settingsBox!.get("pagetop")!.settingValue == "true";
  }

  Future<void> setPageTop(String pageTop) async {
    settingsBox!.put("pagetop", Setting(settingValue: pageTop));
  }
}

class FavouriteServices {
  Box<Favourite>? favoriteBox;

  FavouriteServices() {
    favoriteBox = Hive.box<Favourite>('favorites');
  }

  Future<List<int>> getFavoritePages() async {
    if (favoriteBox == null || favoriteBox!.get("pages") == null) {
      return [];
    }
    return favoriteBox!.get("pages")!.favorites;
  }

  Future<void> setFavoritePages(List<int> favorites) async {
    favoriteBox!.put("pages", Favourite(favorites: favorites));
  }

  Future<void> deleteFavoritePage(int page) async {
    final favPages = await getFavoritePages();
    favPages.remove(page);
    setFavoritePages(favPages);
  }

  Future<List<int>> getFavoriteJuzs() async {
    if (favoriteBox == null || favoriteBox!.get("juzs") == null) {
      return [];
    }
    return favoriteBox!.get("juzs")!.favorites;
  }

  Future<void> setFavoriteJuzs(List<int> favorites) async {
    favoriteBox!.put("juzs", Favourite(favorites: favorites));
  }

  Future<void> deleteFavoriteJuz(int juz) async {
    final favJuzs = await getFavoriteJuzs();
    favJuzs.remove(juz);
    setFavoriteJuzs(favJuzs);
  }
}
