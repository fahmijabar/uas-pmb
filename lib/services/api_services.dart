import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bahan_model.dart';

class ApiService {
  static const String baseUrl = "http://localhost/api_kulkas";

  // ==========================
  // READ DATA
  // ==========================
  Future<List<Bahan>> getBahan() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/read.php"));

      print("READ STATUS : ${response.statusCode}");
      print("READ BODY : ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Bahan.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("ERROR READ : $e");
      return [];
    }
  }

  // ==========================
  // INSERT DATA
  // ==========================
  Future<bool> insertBahan({
    required String nama,
    required String tanggalMasuk,
    required String masaSimpan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/input_bahan.php"),
        body: {
          "nama": nama,
          "tanggal_masuk": tanggalMasuk,
          "masa_simpan": masaSimpan,
        },
      );

      print("INSERT STATUS : ${response.statusCode}");
      print("INSERT BODY : ${response.body}");

      if (response.statusCode == 200) {
        try {
          final result = jsonDecode(response.body);

          print("INSERT RESULT : $result");

          return result["success"] == true;
        } catch (e) {
          print("JSON INSERT ERROR : $e");
          return true;
        }
      }

      return false;
    } catch (e) {
      print("ERROR INSERT : $e");
      return false;
    }
  }

  // ==========================
  // UPDATE DATA
  // ==========================
  Future<bool> updateBahan({
    required String id,
    required String nama,
    required String tanggalMasuk,
    required String masaSimpan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_bahan.php"),
        body: {
          "id": id,
          "nama": nama,
          "tanggal_masuk": tanggalMasuk,
          "masa_simpan": masaSimpan,
        },
      );

      print("UPDATE STATUS : ${response.statusCode}");
      print("UPDATE BODY : ${response.body}");

      if (response.statusCode == 200) {
        print("RAW RESPONSE UPDATE = ${response.body}");

        try {
          final result = jsonDecode(response.body);

          print("SUCCESS VALUE = ${result["success"]}");

          return result["success"] == true;
        } catch (e) {
          print("JSON UPDATE ERROR : $e");

          // Jika database berhasil update
          // tapi response bukan JSON valid
          return true;
        }
      }

      return false;
    } catch (e) {
      print("ERROR UPDATE : $e");
      return false;
    }
  }

  // ==========================
  // DELETE DATA
  // ==========================
  Future<bool> deleteBahan(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_bahan.php"),
        body: {"id": id},
      );

      print("DELETE STATUS : ${response.statusCode}");
      print("DELETE BODY : ${response.body}");

      if (response.statusCode == 200) {
        try {
          final result = jsonDecode(response.body);

          print("DELETE RESULT : $result");

          return result["success"] == true;
        } catch (e) {
          print("JSON DELETE ERROR : $e");
          return true;
        }
      }

      return false;
    } catch (e) {
      print("ERROR DELETE : $e");
      return false;
    }
  }
}
