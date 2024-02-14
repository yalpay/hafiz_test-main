import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/storage.services.dart';

class PageScreen extends StatefulWidget {
  final Ayah ayah;

  const PageScreen({Key? key, required this.ayah}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<PageScreen> {
  bool isLoading = false;
  bool isFavorite = false;
  final ayahServices = AyahServices();
  List<Ayah> page = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() => isLoading = true);

    page = await ayahServices.getPage(widget.ayah.page);

    setState(() => isLoading = false);
  }

  String makeAyahNumber(int ayahNumber) {
    final formatedAyahNumber = NumberFormat('#', 'ar_EG').format(ayahNumber);
    final runes = Runes('   \u{fd3f}$formatedAyahNumber\u{fd3e}');

    return String.fromCharCodes(runes);
  }

  String getPageHeader(Ayah ayah) {
    if (ayah.page > 590) {
      return "Sayfa ${ayah.page.toString()}";
    }
    int donus = 21 - (ayah.page % 20);
    return "${ayah.juz.toString()}.Cüz ${(donus == 21 ? 1 : donus).toString()}.Dönüş";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.star,
              color: isFavorite ? Colors.yellow : Colors.white,
            ),
            onPressed: () async {
              final storageServices = FavouriteServices();
              final pageList = await storageServices.getFavoritePages();
              if (isFavorite) {
                pageList.remove(widget.ayah.page);
                storageServices.setFavoritePages(pageList);
              } else {
                pageList.add(widget.ayah.page);
                storageServices.setFavoritePages(pageList);
              }
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
        title: Text(
          getPageHeader(widget.ayah),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading)
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              else
                Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: page.length,
                      itemBuilder: (context, index) {
                        final ayah = page[index];

                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    textDirection: TextDirection.rtl,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: ayah.originalText,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                            fontFamily: 'Quran',
                                          ),
                                        ),
                                        TextSpan(
                                          text: makeAyahNumber(
                                              ayah.numberInSurah),
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Quran',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(color: Colors.black);
                      },
                    ),
                    const Divider(color: Colors.black),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
