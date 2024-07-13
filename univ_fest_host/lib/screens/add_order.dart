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
  late List<String> nameMenu = [];
  late List<int> priceMenu = [];

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
      body: _menuListView(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          loadOrder();
        },
      ),
    );
  }

  Widget _menuItem(String title) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        onTap: () {
          print("onTap called.");
        }, // タップ
        onLongPress: () {
          print("onLongPress called.");
        }, // 長押し
      ),
    );
  }

  Widget _menuListView(BuildContext context) {
    if (nameMenu.isEmpty) {
      return const Center(child: Text("No Data"));
    }
    return ListView.builder(
      itemCount: nameMenu.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 50,
          child: Center(
            child: _menuItem("${nameMenu[index]} (${priceMenu[index]}円)"),
          ),
        );
      },
    );
  }

  void loadOrder() async {
    nameMenu = [];
    priceMenu = [];
    var imgURL;
    var snapshot = await FirebaseDatabase.instance.ref('menus/$usrID/').get();
    if (!snapshot.exists) return;
    for (var e in snapshot.children) {
      imgURL = storage
          .ref('images/menus/$usrID/${e.key.toString()}.png')
          .getDownloadURL();
      nameMenu.add(e.child("name").value.toString());
      priceMenu.add(int.parse(e.child("price").value.toString()));
    }
  }
}
