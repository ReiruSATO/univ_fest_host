import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RegistMenuView extends StatelessWidget {
  const RegistMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const RegistMenuPage(),
    );
  }
}

class RegistMenuPage extends StatefulWidget {
  const RegistMenuPage({super.key});

  @override
  _RegistMenuPageState createState() => _RegistMenuPageState();
}

class _RegistMenuPageState extends State<RegistMenuPage> {
  // 画像表示用の変数
  ImageProvider? _image;
  File? _imageFile;

  // text input
  final _nameInput = TextEditingController();
  final _priceInput = TextEditingController();

  // ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameInput.text = '';
      _priceInput.text = '0';
      _image = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameInput.dispose();
    _priceInput.dispose();
    _image = null;
  }

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regist Menu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                const Text(
                  'name :',
                  style: TextStyle(fontSize: 24),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: TextField(
                    controller: _nameInput,
                    style: const TextStyle(fontSize: 24),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                const Text(
                  'price :',
                  'price :',
                  style: TextStyle(fontSize: 24),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: TextField(
                    controller: _priceInput,
                    style: const TextStyle(fontSize: 24),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            //  まるやま
            //  画像表示のボタン追加
            //  Padding は余白機能

            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: <Widget>[
                // 左側のただの表示　" photo : "
                const Text(
                  'photo :',
                  style: TextStyle(fontSize: 24),
                ),

                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          await setImage();
                        },
                        child: const Text('画像をアップロード'))),
              ],
            ),
            Flexible(
                child: _image != null ? Image(image: _image!) : Container()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await setMenu();
        },
      ),
    );
  }

  /// フォームの初期化
  void inputClear() {
    setState(() {
      _nameInput.clear();
      _priceInput.clear();
      _image = null;
      _imageFile = null;
    });
  }

  /// 画像をスマホのギャラリーから取得
  /// 選択した画像を_imageにセットする関数
  Future<void> setImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    _imageFile = File(image.path);
    setState(() {
      _image = FileImage(_imageFile!);
    });
  }

  /// FirebaseStorageに選択されている画像をアップロードする関数
  Future<String?> uploadMenuImage(File? imageFile, String menuid) async {
    if (imageFile == null) {
      debugPrint("imageFile is null");
      return null;
    }
    try {
      final menuImgRef =
          FirebaseStorage.instance.ref('images/menus/$userID/$menuid');
      final downloadURL = await menuImgRef.putFile(imageFile).then((value) {
        debugPrint("uploading image completed!");
        return value.ref.getDownloadURL();
      });
      debugPrint("downloadURL: $downloadURL");
      await FirebaseDatabase.instance
          .ref('menus/$userID/$menuid')
          .update({'image': downloadURL});
      return downloadURL;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> setMenu() async {
    if (_nameInput.text == '') return;
    final name = _nameInput.text;
    final price = int.parse(_priceInput.text);
    DatabaseReference ref = FirebaseDatabase.instance.ref('menus/$userID/');
    debugPrint("ref at $userID");
    final snapshot = await ref.get();

    if (!snapshot.exists) return;
    int dirNum = 0;
    for (var e in snapshot.children) {
      if (e.child("name").value == name) break;
      dirNum++;
    }

    final imageURL = await uploadMenuImage(_imageFile, dirNum.toString());
    debugPrint("imageURL: $imageURL");

    await ref.update({
      "$dirNum/name": name,
      "$dirNum/price": price,
      "$dirNum/image": imageURL,
    });

    debugPrint("setting menu $name completed!");

    inputClear();
  }
}
