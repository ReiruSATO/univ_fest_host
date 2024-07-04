import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyOrderListPage(),
    );
  }
}

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  _MyOrderListPageState createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
  final _controller = TextEditingController();
  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _controller,
              style: const TextStyle(
                fontSize: 24,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          fire();
        },
      ),
    );
  }

  void fire() async {
    var msg = '$usrID\n';
    final ref = FirebaseDatabase.instance.ref('menus');
    /*for (var e in snapshot.children) {
      /*for (var ee in e.children) {
        for (var eee in ee.child('items').children) {
          msg += '${eee.value},';
        }
        msg += '\n';
      }*/
    }*/

    /*FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('order-list').get();
    for (var element in snapshot.docChanges) {
      final name = element.doc.get('name');
      final price = element.doc.get('price');
      final quantity = element.doc.get('quantity');
      msg += "$name: $price yen x$quantity\n";
    }*/
    _controller.text = msg;
  }
}
