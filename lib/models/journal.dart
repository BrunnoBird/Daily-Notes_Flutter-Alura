import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  //Contrutor vazio
  Journal.empty({required int id})
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        userId = id;

//Convertendo de JSON para MAP -> Criando um OBJETO dart. (recebe da API)
  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["created_at"]),
        updatedAt = DateTime.parse(map["updated_at"]),
        userId = map["userId"];

  //Transforma em MAP para enviar para API
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "userId": userId,
    };
  }

  @override
  String toString() {
    return "content: $content \ncreated_at: $createdAt\nupdated_at: $updatedAt\nuserId: $userId";
  }
}
