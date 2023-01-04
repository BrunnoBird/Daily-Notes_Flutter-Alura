import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = 'http://192.168.0.97:3000/';
  static const String resouce = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [HttpInterceptor()]);

  String getUrl() {
    return "$url$resouce";
  }

  Future<bool> register(Journal journal) async {
    //convertando meu objeto para json depois de transforma-lo para MAP.
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {'Content-type': 'application/json'},
      body: jsonJournal,
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(
      Uri.parse(getUrl()),
    );
    if (response.statusCode != 200) {
      throw Exception();
    }

    List<Journal> list = [];
    //Transformo de String para JSON
    List<dynamic> listDynamic = json.decode(response.body);

    //1- Itero para cada list do JSON.
    //2- Transformo cada item da lista do JSON em um MAP usndo o fromMap.
    //3- Journal.fromMap -> crio um objeto Journal para adicionar na lista final.
    //4 - Retorno a justa de Objetos Journal para a tela.

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> edit(String id, Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {'Content-type': 'application/json'},
      body: jsonJournal,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(String id) async {
    http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
