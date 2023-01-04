import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  int? userId;

  //Chamado apenas quando a tela é construida pela primeira vez.
  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
            onPressed: () => refresh(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: (userId != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                refreshFunction: refresh,
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                userId: userId!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void refresh() {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('accessToken');
      String? email = prefs.getString('email');
      int? id = prefs.getInt('id');

      if (token != null && email != null && id != null) {
        setState(() {
          userId = id;
        });

        service
            .getAll(id: id.toString(), token: token)
            .then((List<Journal> listJournal) {
          setState(() {
            database = {};
            for (Journal itemJournal in listJournal) {
              database[itemJournal.id] = itemJournal;
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}
