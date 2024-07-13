import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddOrderView extends StatelessWidget {
  AddOrderView({super.key});
  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyAddOrderPage(),
    );
  }
}

class MyAddOrderPage extends StatefulWidget {
  const MyAddOrderPage({super.key});

  @override
  _MyAddOrderPageState createState() => _MyAddOrderPageState();
}

class _MyAddOrderPageState extends State<MyAddOrderPage> {
  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const Text('Add Order'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          loadOrder();
        },
      ),
    );
  }

  void loadOrder() async {
    var imgRef = storage.ref().child("/images/menus/$usrID/1.jpg");
    try {
      const oneMegaByte = 1024 * 1024;
      final Uint8List? data = await imgRef.getData(oneMegaByte);
      //for (var e in data!) {}
    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Storage Error"),
              content: const Text("Failed Access"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
  }
}
