import 'package:flutter/material.dart';
import 'package:univ_fest_host/screens/add_order.dart';
import 'package:univ_fest_host/screens/order_list.dart';
import 'package:univ_fest_host/screens/regist_menu.dart';
import 'package:univ_fest_host/screens/scan.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<CameraDescription> cameras = await availableCameras();
  final CameraDescription firstCamera = cameras.first;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Univ Fest Host',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff2196f3),
        canvasColor: const Color(0xfffafafa),
      ),
      home: MyHomePage(camera: camera),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = <Tab>[
    Tab(
      text: 'Order List',
      icon: Icon(Icons.format_list_bulleted, color: Colors.white),
    ),
    Tab(
      text: 'Add order',
      icon: Icon(Icons.format_list_bulleted_add, color: Colors.white),
    ),
    Tab(
      text: 'Scan',
      icon: Icon(Icons.camera, color: Colors.white),
    ),
    Tab(
      text: 'Regist Menu',
      icon: Icon(Icons.add_to_photos, color: Colors.white),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    doSignin();
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _buildTabPages(),
      ),
      bottomNavigationBar: Container(
        color: Colors.lightBlueAccent,
        child: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
    );
  }

  List<Widget> _buildTabPages() {
    return [
      const OrderListView(),
      AddOrderView(),
      const ScanView(),
      const RegistMenuView(),
    ];
  }

  void doSignin() {
    signInWithGoogle().then((value) {
      if (value.user != null) {
        //fire();
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth?.accessToken,
      idToken: auth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
