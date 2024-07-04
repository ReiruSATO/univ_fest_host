import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddOrderView extends StatelessWidget {
  AddOrderView({super.key});
  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';

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
          addOrder();
        },
      ),
    );
  }

  void addOrder() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('memus');
    await ref.set({
      "name": "ラーメン屋",
    });
  }
}
