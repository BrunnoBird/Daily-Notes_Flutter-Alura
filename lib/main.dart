import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';

Future<void> main() async {
  //afirmando para o flutter que minha main é assincrona.
  WidgetsFlutterBinding.ensureInitialized();

  bool isLogged = await verifyToken();
  runApp(MyApp(isLogged: isLogged));
}

Future<bool> verifyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  if (token != null) {
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  const MyApp({Key? key, required this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: (isLogged) ? 'home' : 'login',
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'add-journal') {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["is_editing"];

          return MaterialPageRoute(builder: (context) {
            return AddJournalScreen(
              journal: journal,
              isEditing: isEditing,
            );
          });
        }
        return null;
      },
    );
  }
}
