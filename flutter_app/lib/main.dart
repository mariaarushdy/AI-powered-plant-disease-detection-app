import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:flutter_application_1/pages/terms.dart';
import 'package:flutter_application_1/pages/privacy.dart';
import 'package:flutter_application_1/pages/getintouch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PlantGuardian - Your Comprehensive Plant Health Monitoring Solution!',
        debugShowCheckedModeBanner: false,
        home: MySplash(),
        routes: {
          '/terms': (context) => TermsPage(),
          '/privacy': (context) => PrivacyPolicyPage(),
          '/get_in_touch': (context) => GetInTouchPage(),
        }
    );
  }
}