import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff2196f3),
        canvasColor: const Color(0xfffafafa),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> tabs = <Tab>[
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
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab App'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return createTab(tab);
        }).toList(),
      ),
      bottomNavigationBar: Container(
        color: Colors.lightBlueAccent,
        child: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
    );
  }

  Widget createTab(Tab tab) {
    return Center(
      child: Text(
        'This is "${tab.text}" Tab.',
        style: const TextStyle(
          fontSize: 32,
          color: Colors.blue,
        ),
      ),
    );
  }
}
