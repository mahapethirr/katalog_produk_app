import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Box appBox = Hive.box('appBox');
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = appBox.get('dark_mode', defaultValue: false);
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    appBox.put('dark_mode', value);
  }

  @override
  Widget build(BuildContext context) {
    final lightTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    final darkTextTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Produk',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xffF6F7FB),
        cardColor: Colors.white,
        dividerColor: const Color(0xffECECF2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6C63FF),
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        textTheme: lightTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffF6F7FB),
          foregroundColor: Color(0xff171725),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff090B12),
        cardColor: const Color(0xff121722),
        dividerColor: const Color(0xff1F2633),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff7B6DFF),
          secondary: Color(0xff8E63FF),
          surface: Color(0xff121722),
          onSurface: Color(0xffF4F7FB),
        ),
        textTheme: darkTextTheme.apply(
          bodyColor: const Color(0xffF4F7FB),
          displayColor: const Color(0xffF4F7FB),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff090B12),
          foregroundColor: Color(0xffF4F7FB),
          elevation: 0,
        ),
      ),
      home: HomePage(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}
