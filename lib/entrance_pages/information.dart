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
          child: Column(
            children: [
              Text("Bu uygulama"),
            ],
          ),
        ),
      ),
    );
  }
}
