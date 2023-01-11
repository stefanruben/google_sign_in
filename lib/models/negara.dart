import 'dart:convert';

import 'package:http/http.dart' as http;

class Negara{
  String name;
  //String username;

  Negara({
    required this.name,
    //required this.username
  });

  factory Negara.fromJson(Map<String, dynamic> json) => Negara(
    name: json["name"], 
    //username: json["username"]
  );

  Future<Negara> getNegara() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    if (response.statusCode == 200) {
      return Negara.fromJson(json.decode(response.body)[0]);
    } else {
      throw Exception('Failed to load post');
    }
  }
}