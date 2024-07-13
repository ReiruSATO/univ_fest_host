import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:univ_fest_host/screens/scan.dart';

class ScanDataWidget extends StatelessWidget {
  final BarcodeCapture? scandata; // スキャナーのページから渡されたデータ
  const ScanDataWidget({
    super.key,
    this.scandata,
  });

  @override
  Widget build(BuildContext context) {
    // コードから読み取った文字列
    String codeValue = scandata?.barcodes.first.rawValue ?? 'null';
    // コードのタイプを示すオブジェクト
    BarcodeType? codeType = scandata?.barcodes.first.type;
    // コードのタイプを文字列にする
    String cardTitle = "[${'$codeType'.split('.').last}]";
    // 読み取った内容を表示するウィジェット
    dynamic cardSubtitle = Text(codeValue,
        style: const TextStyle(fontSize: 23, color: Color(0xFF553311)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('スキャンの結果'),
      ),
      body: Card(
        color: const Color(0xFFBBFFDD),
        elevation: 5,
        margin: const EdgeInsets.all(9),
        child: ListTile(
          title: Text(
            cardTitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: cardSubtitle,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // ここにボタンを押した時に呼ばれるコードを書く
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanView()),
          );
        },
        label: const Text('スキャン画面へ'),
      ),
    );
  }
}
