import 'package:connecwalletflutter/ConnectWallets.dart';
import 'package:connecwalletflutter/HomePage.dart';
import 'package:connecwalletflutter/PlaygroundScreen.dart';
import 'package:connecwalletflutter/walletHomePage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const WalletHomePage(),
    );
  }
}

