import 'package:buzzit/homepage.dart';
import 'package:buzzit/signinpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const MaterialColor myColor = MaterialColor(
    _myColorPrimaryValue,
    <int, Color>{
      50: Color(0xFFf6eaec),
      100: Color(0xFFe5bfc5),
      200: Color(0xFFd4959f),
      300: Color(0xFFc36b78),
      400: Color(0xFFb24051),
      500: Color(0xFFa92b3e),
      600: Color(0xFF872232),
      700: Color(0xFF441119),
      800: Color(0xFF22090c),
      900: Color(0xFF110406),
    },
  );
  static const int _myColorPrimaryValue = 0xFFa92b3e;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: myColor,
        scaffoldBackgroundColor: myColor.shade50,
        cardColor: const Color(0xFFFFFFFF),
        canvasColor: myColor.shade100,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: myColor.shade700,
            fontSize: 35,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: myColor.shade700,
            fontSize: 15,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            color: myColor.shade300,
            fontSize: 15,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          headline4: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            color: myColor.shade700,
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            color: myColor.shade700,
            fontSize: 15,
            fontFamily: 'OpenSans',
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    String? ps = prefs.getString('name');
    if (ps != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
