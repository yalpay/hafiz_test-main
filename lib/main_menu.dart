import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hafiz_test/favourites/favorites.dart';

import 'package:hafiz_test/juz/juz_list_screen.dart';
import 'package:hafiz_test/juz/test_by_juz.dart';
import 'package:hafiz_test/settings_dialog.dart';
import 'package:hafiz_test/surah/surah_list_screen.dart';
import 'package:hafiz_test/widget/button.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Emin misin?'),
            content: const Text('Çıkmak istiyor musun?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Evet'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          },
          child: const SizedBox(
            width: 138,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Favoriler'),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'HAFIZ',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.blueGrey,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return const SettingDialog();
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: const Text(
                  'Sureden Sor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  FlutterIslamicIcons.quran2,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const SurahListScreen();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: const Text(
                  'Cüzden Sor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  FlutterIslamicIcons.quran,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const JuzListScreen();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: const Text(
                  'Bütün Kuran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  FlutterIslamicIcons.solidQuran2,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const TestByJuz(juzNumber: 0);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
