import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:univ_fest_host/screens/widgets/scan_data.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyScanPage(),
    );
  }
}

class MyScanPage extends StatefulWidget {
  const MyScanPage({super.key});

  @override
  State<MyScanPage> createState() => _MyScanPageState();
}

class _MyScanPageState extends State<MyScanPage> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF66FF99),
        title: const Text('QR Code Scanner'),
      ),
      body: Builder(
        builder: (context) {
          return MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
            onDetect: (scandata) {
              setState(() {
                controller.stop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return ScanDataWidget(scandata: scandata);
                    },
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
