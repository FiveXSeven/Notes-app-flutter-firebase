// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/Pages/Home/home_page.dart';
import 'package:flutterbase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
