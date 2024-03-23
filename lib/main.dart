import 'package:flutter/material.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/entrance_pages/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  openHiveBox();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Afeez(),
    ),
  );
}

void openHiveBox() async {
  Hive.registerAdapter(SettingAdapter());
  Hive.registerAdapter(FavouriteAdapter());
  await Hive.initFlutter();
  await Hive.openBox<Setting>('setting');
  await Hive.openBox<Favourite>('favorites');
}

class Afeez extends StatefulWidget {
  const Afeez({super.key});

  @override
  State<StatefulWidget> createState() => _Afeez();
}

class _Afeez extends State<Afeez> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashScreen());
  }
}
