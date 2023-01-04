import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/weekday.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;

  AddJournalScreen({
    super.key,
    required this.journal,
    required this.isEditing,
  });

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //build é chamado quando é construido
    _contentController.text = journal.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
            fontSize: 24,
          ),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('accessToken');

      if (token != null) {
        String content = _contentController.text;
        journal.content = content;

        JournalService service = JournalService();

        if (isEditing) {
          service.edit(journal.id, journal, token: token).then((value) => {
                Navigator.pop(context, value),
              });
        } else {
          service.register(journal, token: token).then((value) => {
                Navigator.pop(context, value),
              });
        }
      }
    });
  }
}
