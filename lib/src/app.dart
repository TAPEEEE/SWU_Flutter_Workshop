import 'package:demo0/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';

main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPages());
  }
}