import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hafiz_test/main_menu.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final welcomingMessages = [
    "Gökyüzünü yıldızlar, yeryüzünü hafızlar süsler",
    "İlim öyle bir şehirdir ki geceni gündüze katmadan fetholunmaz",
    "Hafızlık meşakkatli seferin hakikatli zaferine talip olmaktır",
    "Yürü hafızım! Geceler senin hafızlık aşkına şahittir",
    "Sen aşkı sabah namazından önce ders veren hafızlara sor",
    "Sabır hafızım sabır, Kur'an en güzel yoldaştır",
    "Ümmetimin en şereflileri, Kur'an'ı ezberleyenlerdir (s.a.v)",
    "Kur'an'ı ezberleyen kimse, kıyamette cennet ehlinin reisleridir (s.a.v)"
  ];
  final random = Random();

  Future<bool> _splash() async {
    await Future.delayed(const Duration(milliseconds: 3500), () {});
    return true;
  }

  @override
  void initState() {
    super.initState();
    _splash().then((status) {
      if (status) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) {
            return const MainMenu();
          }),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/6.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.greenAccent,
            child: Container(
              margin: const EdgeInsets.only(top: 220),
              child: Column(
                children: [
                  const Text(
                    'HAFIZ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    welcomingMessages[random.nextInt(welcomingMessages.length)],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'pacifico',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
