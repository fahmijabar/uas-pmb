import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bahan_model.dart';

class ApiService {
  final String baseUrl = "http://localhost/api_kulkas";

  Future<List<Bahan>> getBahan() async {
    final response = await http.get(
      Uri.parse("$baseUrl/read.php"),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((item) => Bahan.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}

//si anu kontol