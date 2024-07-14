import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:univ_fest_host/screens/scan.dart';
import 'package:univ_fest_host/data_set.dart';

class ScanDataWidget extends StatelessWidget {
  final BarcodeCapture? scandata; // スキャナーのページから渡されたデータ
  const ScanDataWidget({
    super.key,
    this.scandata,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyScanDataPage(scandata: scandata),
    );
  }
}

class MyScanDataPage extends StatefulWidget {
  const MyScanDataPage({super.key, this.scandata});
  final scandata;

  @override
  _MyScanDataPageState createState() => _MyScanDataPageState();
}

class _MyScanDataPageState extends State<MyScanDataPage> {
  late BarcodeCapture scandata;

  late String usrID;
  late String orderID;
  late DatabaseReference orderRef;
  late DatabaseReference menuRef;
  late Buyer buyer;
  late String orderURL, menuURL;

  @override
  void initState() {
    super.initState();
    usrID = FirebaseAuth.instance.currentUser?.uid ?? '';
    buyer = Buyer(usrID);
  }

  @override
  Widget build(BuildContext context) {
    scandata = widget.scandata;
    // コードから読み取った文字列
    String orderID = scandata.barcodes.first.rawValue ?? 'null';
    // 読み取った内容を表示するウィジェット
    dynamic cardSubtitle = Text('user:${buyer.user}',
        style: const TextStyle(fontSize: 23, color: Color(0xFF553311)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Card(
            color: const Color(0xFFBBFFDD),
            elevation: 5,
            margin: const EdgeInsets.all(9),
            child: ListTile(
              title: Text(
                'ID:$orderID\n price:${buyer.price}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: cardSubtitle,
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              ElevatedButton(
                onPressed: () {
                  searchOrder(buyer, orderID);
                },
                child: const Text(
                  '計算',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    buyer.reset();
                  });
                },
                child: const Text(
                  '完了',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanView()),
          );
        },
        label: const Text('スキャン画面へ'),
      ),
    );
  }

  void searchOrder(Buyer buyer, String orderID) async {
    buyer.price = 0;
    orderURL = 'orders/$usrID/$orderID';
    orderRef = FirebaseDatabase.instance.ref(orderURL);
    final orderSnapshot = await orderRef.get();
    menuURL = 'menus/$usrID';
    menuRef = FirebaseDatabase.instance.ref(menuURL);

    final itemSnapshot = await orderRef.child("items").get();
    for (var e in itemSnapshot.children) {
      String key = e.key.toString();
      String val = e.value.toString();
      final menuSnapshot = await menuRef.child(key).get();
      int price = int.parse(menuSnapshot.child("price").value.toString());
      buyer.price += price * int.parse(val);
    }
    setState(() {
      buyer.price;
    });
    print('total:${buyer.price}');
    for (var e in orderSnapshot.children) {
      if (e.key.toString() == 'user') {
        setState(() {
          buyer.user = e.value.toString();
        });
      }
    }
  }
}
