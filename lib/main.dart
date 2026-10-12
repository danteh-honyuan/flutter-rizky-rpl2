import 'package:flutter/material.dart';
import 'package:hello/sized_expanded_stack/LatihanLayout.dart';
import 'package:hello/sized_expanded_stack/LatihanTiga.dart';
import 'package:hello/list_grid_view/ListView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const ContohListView(),
      ),
    );
  }
}