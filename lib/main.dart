import 'package:flutter/material.dart';
import 'package:test_technique_colicoli_flutter/src/views/ui/pages/Page_home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/Page_home": (context) => const Page_home(),
      },
      theme: ThemeData(primaryColor: Colors.green),
      initialRoute: '/Page_home',
    );
  }
}
