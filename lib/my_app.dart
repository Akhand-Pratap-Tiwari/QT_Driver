import 'package:flutter/material.dart';

import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick TAXI Driver',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(useMaterial3: true, appBarTheme: const AppBarTheme(backgroundColor: Colors.amber, foregroundColor: Colors.black)),
      home: const AuthGate(),
    );
  }
}
