import 'package:flutter/material.dart';
import 'package:wetrip/welcome_screen.dart';
import 'data_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataLoader = DataLoader();
  await dataLoader.loadData();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WelcomeP());
  }
}
