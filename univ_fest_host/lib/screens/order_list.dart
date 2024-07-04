import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Text(
              'Order List Page',
              style: TextStyle(
                fontSize: 32,
                fontWeight: ui.FontWeight.w500,
              ),
            ),
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
        child: const Icon(Icons.open_in_new),
        onPressed: () {
          fire();
        },
      ),
    );
  }

  void fire() async {
    var msg = '';
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('order-list').get();
    for (var element in snapshot.docChanges) {
      final name = element.doc.get('name');
      final price = element.doc.get('price');
      final quantity = element.doc.get('quantity');
      msg += "$name: $price yen x$quantity\n";
    }
    /*final dl = await firestore.collection('order-list').get();
    final name = dl.docChanges[3].doc.get('name');
    final price = dl.docChanges[3].doc.get('price');
    final quantity = dl.docChanges[3].doc.get('quantity');
    msg = '$name: $price yen x$quantity';*/
    _controller.text = msg;
  }
}
