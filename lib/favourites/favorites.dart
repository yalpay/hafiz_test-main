import 'package:flutter/material.dart';
import 'package:hafiz_test/services/storage.services.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<FavoritesScreen> {
  bool isLoading = false;
  List<int> juzList = [];
  List<int> pageList = [];
  final storageServices = FavouriteServices();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageList = await storageServices.getFavoritePages();
    juzList = await storageServices.getFavoriteJuzs();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoriler"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Column(
                  children: [
                    ...pageList
                        .map(
                          (e) => InkWell(
                            child: Card(
                              child: Container(
                                height: 50,
                                width: 200,
                                padding: const EdgeInsets.all(9),
                                child: Row(
                                  children: [
                                    Text(
                                      '$e. Sayfa',
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () {
                                          setState(() => pageList.remove(e));
                                          storageServices.deleteFavoritePage(e);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    ...juzList
                        .map(
                          (e) => InkWell(
                            child: Card(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '$e. Cüz',
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() => juzList.remove(e));
                              storageServices.deleteFavoriteJuz(e);
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
        ),
      ),
    );
  }
}
