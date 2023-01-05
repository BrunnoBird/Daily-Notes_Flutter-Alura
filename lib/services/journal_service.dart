import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  String url = WebClient.url;
  http.Client client = WebClient().client;
  static const String resouce = "journals/";

  String getUrl() {
    return "$url$resouce";
  }

  Future<bool> register(Journal journal, {required String token}) async {
    //convertando meu objeto para json depois de transforma-lo para MAP.
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException;
      }
      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll({
    required String id,
    required String token,
  }) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException;
      }
      throw HttpException(response.body);
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

  Future<bool> edit(String id, Journal journal, {required String token}) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException;
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> delete(String id, {required String token}) async {
    http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException;
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class TokenNotValidException implements Exception {}
