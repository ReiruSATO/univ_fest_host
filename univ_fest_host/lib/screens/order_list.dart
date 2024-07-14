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
                fontSize: 20,
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
    var msg = '';
    final ref = FirebaseDatabase.instance.ref('orders/$usrID');
    final snapshot = await ref.get();
    for (var e in snapshot.children) {
      msg += "Order ID: ${e.key.toString()} \n";
    }
    _controller.text = msg;
  }
}
