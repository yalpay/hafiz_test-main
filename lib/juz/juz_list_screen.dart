import 'package:flutter/material.dart';
import 'package:hafiz_test/juz/test_by_juz.dart';
import 'package:hafiz_test/services/storage.services.dart';

class JuzListScreen extends StatefulWidget {
  const JuzListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => JuzsPage();
}

class JuzsPage extends State<JuzListScreen> {
  bool isLoading = false;
  List<int> juzList = [];
  final storageServices = FavouriteServices();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    juzList = await storageServices.getFavoriteJuzs();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cüzler'),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? const CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: Colors.blueGrey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                final juzNumber = index + 1;
                bool isFavorite = juzList.contains(juzNumber);
                return InkWell(
                  child: Card(
                    child: SizedBox(
                      height: 50,
                      child: ListTile(
                        trailing: IconButton(
                          icon: Icon(
                            Icons.star,
                            color: isFavorite ? Colors.yellow : Colors.blueGrey,
                          ),
                          onPressed: () async {
                            if (isFavorite) {
                              juzList.remove(juzNumber);
                              storageServices.setFavoriteJuzs(juzList);
                            } else {
                              juzList.add(juzNumber);
                              storageServices.setFavoriteJuzs(juzList);
                            }
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                        leading: Text(
                          '$juzNumber. Cüz',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TestByJuz(
                          juzNumber: juzNumber,
                          title: 'Cüz Listesi',
                        );
                      },
                    ));
                  },
                );
              },
            ),
    );
  }
}
