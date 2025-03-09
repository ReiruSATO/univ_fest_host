import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univ_fest_host/main.dart';
import '../utils/authentication.dart';

class ShopInfoScreen extends StatefulWidget {
  const ShopInfoScreen({super.key});

  @override
  State<ShopInfoScreen> createState() => _ShopInfoScreenState();
}

class _ShopInfoScreenState extends State<ShopInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  ImageProvider? _image;
  File? _imageFile;
  // ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MyHomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: Colors.blueGrey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: Colors.blueGrey.withOpacity(0.3),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16.0),
              Text(
                _user.displayName!,
                style: const TextStyle(
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16.0),
              _isSigningOut
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.redAccent,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushReplacement(_routeToSignInScreen());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
              const Padding(padding: EdgeInsets.all(10)),
              Flexible(
                  child: ElevatedButton(
                      onPressed: () async {
                        await setImage();
                        await uploadMenuImage(_imageFile);
                      },
                      child: const Text('画像をアップロード'))),
            ],
          ),
        ),
      ),
    );
  }

  /// FirebaseStorageに選択されている画像をアップロードする関数
  Future<String?> uploadMenuImage(File? imageFile) async {
    if (imageFile == null) {
      debugPrint("imageFile is null");
      return null;
    }
    try {
      final shopImgRef =
          FirebaseStorage.instance.ref('images/shops/$userID/image');
      final downloadURL = await shopImgRef.putFile(imageFile).then((value) {
        debugPrint("uploading image completed!");
        return value.ref.getDownloadURL();
      });
      debugPrint("downloadURL: $downloadURL");
      await FirebaseDatabase.instance
          .ref('shops/$userID')
          .update({'image': downloadURL});
      return downloadURL;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
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
}
