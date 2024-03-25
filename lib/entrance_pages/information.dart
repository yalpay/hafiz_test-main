import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Info();
}

class Info extends State<InformationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Uygulama Hakkında",
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: const SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      style: TextStyle(fontSize: 15),
                      "Bu uygulama ile Kur'anı Kerim den ezberlerinizi test edebilirsiniz. Hafız olanlar mevcut ezberlerini gözden geçirebilir, "
                      "hafızlık sınavlarına hazırlanabilirler.\n\nUygulama şu şekilde çalışır: İstenen cüzden, istenen sureden veya tüm Kur'an dan "
                      "karşınıza rasgele bir ayet çıkar ve sizden bir sonraki ayeti tamamlamanız beklenir. Otomatik olarak sayfa başından bir ayet "
                      "çıkar ve karşınıza çıkan ayeti önce Kabe imamından dinlersiniz. Ardından dilerseniz ses kaydı başlatırsınız ve sonraki ayeti "
                      "okumaya başlarsınız. Ses kaydı başlatmanız durumunda uygulama sesinizi kaydeder ve sonraki ayet ile karşılaştırır, eğer doğru "
                      "okuduysanız otomatik olarak sonraki ayet yüklenir. Yanlış okuma durumunda yanlış okuduğunuz kısım gösterilir. Bu bölümde "
                      "mahreçlere dikkat ederek, tecvid kuralları ile okumak önemlidir. Ayarlar kısmında ayeti Kabe imamından dinleme özelliğini "
                      "kaldırabilir, veya okuyuş hızını ayarlayabilirsiniz. Rasgele çıkan ayetin sayfa başından olup olmamasını ayarlayabilirsiniz. "
                      "Test ekranında ayetin bulunduğu sayfanın tamamını görüntüleyebilir, bir sonraki veya bir önceki ayete hızlı geçiş yapabilirsiniz. "
                      "Ezberinizin kuvvetli olduğu bölümleri favorilere alabilir, test bölümünde bu kısımlardan sorulmamasını sağlayabilirsiniz. "
                      "Örneğin 15. cüzünüz sağlam ise bu cüzü favoriledikten sonra 'Bütün Kur'an dan Sor' seçeneğini tıklarsanız bu cüzden "
                      "soru gelmeyecektir. Benzer şekilde 1.cüzün 1.dönüşü, yani 20. sayfanız sağlam ise bu sayfayı favorileyerek bu sayfadan soru "
                      "gelmemesini sağlayabilirsiniz.\n\nAllah okuduklarımızla amel edebilmeyi nasip eylesin"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
