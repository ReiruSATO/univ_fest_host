import 'package:flutter/material.dart';
import 'package:univ_fest_host/main.dart';

class RegistMenuView extends StatelessWidget {
  const RegistMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regist Menu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const Text('Regist Menu'),
      ),
    );
  }
}
