import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para chamar o sharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final modoEscuro = prefs.getBool('modo_escuro') ?? false;

  runApp(MyApp(modoEscuroInicial: modoEscuro));
}

class MyApp extends StatefulWidget {
  final bool modoEscuroInicial;
  const MyApp({Key? key, required this.modoEscuroInicial}) : super(key: key);

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.modoEscuroInicial ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme(ThemeMode novoTema) {
    setState(() {
      _themeMode = novoTema;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'to do it!',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}
