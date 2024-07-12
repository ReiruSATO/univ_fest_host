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

  /*
  // まるやま
  // 画像を入れられるけど，Xfileは画像形式ではない
  XFile? _image;
  final imagePicker = ImagePicker();
  */

  //  まるやま
  ImageProvider? _image;
  bool _isImageLoaded = false; // 画像をすでにダウンロードしたかどうかの判定用

  final usrID = FirebaseAuth.instance.currentUser?.uid ?? '';
  final _nameInput = TextEditingController();
  final _priceInput = TextEditingController();

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

  /*
  // まるやま
  // ギャラリーから写真を取得する関数
  Future getImageFromGarally() async {
    // await　は非同期にするため
    // firebase の strage から持ってくる
    final pickedFile = await imagePicker.pickImage(source: FirebaseStorage.instance);
    setState(() {
      if (pickedFile != null) {
        //その取得したデータを変数に入れ
        _image = XFile(pickedFile.path);
        // ↑つまりこいつが画像データ
        // =========ここまで===========
      }
    });
  }
  */

  //まるやま
  // _image に画像が入る関数
  void _downloadImage(String url) async {
    if (!_isImageLoaded) {  // 画像をまだダウンロードしていない場合に処理を実行
        // Firebase Storage上の画像のURLを取得
        String downloadURL =
            await FirebaseStorage.instance.ref(url).getDownloadURL();
        // URLから画像を取得
        final imgProvider = CachedNetworkImageProvider(downloadURL);
        setState(() {
          //  ここで完了
            _image = imgProvider;
            _isImageLoaded = true;
        });
    }
  }



  @override
  Widget build(BuildContext context) {
    /*
    //　まるやま
    if (!_isImageLoaded) { // 画像をまだダウンロードしていない場合に関数を実行
        // 引数にFirebase Storage上の画像のURL（例: 'Images/sample.png'）を渡す
        _downloadImage('images/menus/AsrU482t2zV89FS2s9KomNJjIDz2/0.png');
    }
    */

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

                // 実際の入力する場所
                /*
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                    child: _image == null
                        ? CircularProgressIndicator() // _imageがnullになっている間はグルグルを表示
                        : Container(
                            decoration: BoxDecoration(
                                //選択した画像表示
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _image!
                                )
                            )
                        ),
                ),
              ],
            ),
            */
            const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: FloatingActionButton(
                    // () => はボタンを押したときに発動 ( ないとボタン描写されたタイミング )
                    onPressed: () => _downloadImage('images/menus/AsrU482t2zV89FS2s9KomNJjIDz2/0.png'),
                    child: const Icon(Icons.movie_creation)
                    
                    //ElevatedButton(onPressed: () => _downloadImage('images/menus/AsrU482t2zV89FS2s9KomNJjIDz2/0.png'),)
                  )
                ),
              ],
            ),

          ],
        ),
      ),

      

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setMenu();
        },
      ),
    );
  }

  

  void setMenu() async {
    if (_nameInput.text == '') return;
    var name = _nameInput.text;
    var price = int.parse(_priceInput.text);
    var image = _image;
    setState(() {
      _nameInput.text = '';
      _priceInput.text = '0';
      _image = null;
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref('menus/$usrID/');
    print("ref at $usrID");
    final snapshot = await ref.get();

    if (!snapshot.exists) return;
    int dirNum = 0;
    for (var e in snapshot.children) {
      if (e.child("name").value == name) break;
      dirNum++;
    }
    await ref.update({
      "$dirNum/name": name,
      "$dirNum/price": price,
      "$dirNum/image": image,
    });
  }
}
