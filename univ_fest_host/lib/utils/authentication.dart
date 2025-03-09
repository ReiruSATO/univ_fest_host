import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:univ_fest_host/firebase_options.dart';
import 'package:univ_fest_host/main.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    try {
      FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      User? user = FirebaseAuth.instance.currentUser;

      // >>> Firebase Analytics >>>
      await FirebaseAnalytics.instance
          .setDefaultEventParameters({'version': '1.2.3'});

      // >>> Firebase AppCheck >>>
      await FirebaseAppCheck.instance.activate(
        // Play Integrity provider
        // now debug provider is used for testingandroidProvider:

        androidProvider:
            kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
        // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        appleProvider:
            kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
      );

      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('User granted permission: ${settings.authorizationStatus}');

      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $fcmToken');

      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        // TODO: If necessary send token to application server.

        // Note: This callback is fired at each app startup and whenever a new
        // token is generated.
      }).onError((err) {
        // Error getting token.
      });

      if (user != null && context.mounted) {
        final List<CameraDescription> cameras = await availableCameras();
        final CameraDescription firstCamera = cameras.first;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      }

      return firebaseApp;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Error initializing Firebase');
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return user;
  }

  static User? getAuthenticatedUser({required BuildContext context}) {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (!context.mounted) return;
    }
  }
}
