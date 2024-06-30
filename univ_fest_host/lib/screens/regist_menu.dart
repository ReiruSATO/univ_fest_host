import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegistMenuView extends StatelessWidget {
  const RegistMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const RegistMenuPage(),
    );
  }
}

class RegistMenuPage extends StatefulWidget {
  const RegistMenuPage({super.key});

  @override
  _RegistMenuPageState createState() => _RegistMenuPageState();
}

class _RegistMenuPageState extends State<RegistMenuPage> {
  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';
  final _nameInput = TextEditingController();
  final _priceInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameInput.text = '';
      _priceInput.text = '0';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameInput.dispose();
    _priceInput.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regist Menu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                const Text(
                  'name :',
                  style: TextStyle(fontSize: 24),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: TextField(
                    controller: _nameInput,
                    style: const TextStyle(fontSize: 24),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                const Text(
                  'price:',
                  style: TextStyle(fontSize: 24),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: TextField(
                    controller: _priceInput,
                    style: const TextStyle(fontSize: 24),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setMenu();
        },
      ),
    );
  }

  void setMenu() async {
    if (_nameInput.text == '') return;
    var name = _nameInput.text;
    var price = int.parse(_priceInput.text);
    setState(() {
      _nameInput.text = '';
      _priceInput.text = '0';
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref('menus/$usrID/');
    final snapshot = await ref.get();

    if (!snapshot.exists) return;
    int dirNum = 0;
    for (var e in snapshot.children) {
      if (e.child("name").value == name) break;
      dirNum++;
    }
    await ref.update({
      "$dirNum/name": name,
      "$dirNum/price": price,
    });
  }
}
