import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  List kategoriList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getKategori();
  }

  Future<void> getKategori() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/api_kulkas/read_kategori.php'),
      );

      print("STATUS KATEGORI : ${response.statusCode}");
      print("BODY KATEGORI : ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          kategoriList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data kategori';
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR KATEGORI : $e");

      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  IconData getKategoriIcon(String namaKategori) {
    switch (namaKategori.toLowerCase()) {
      case 'sayuran':
        return Icons.eco;
      case 'buah':
        return Icons.apple;
      case 'daging':
        return Icons.set_meal;
      case 'minuman':
        return Icons.local_drink;
      case 'susu':
        return Icons.local_cafe;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Bahan'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : kategoriList.isEmpty
          ? const Center(
              child: Text('Belum ada kategori', style: TextStyle(fontSize: 16)),
            )
          : RefreshIndicator(
              onRefresh: getKategori,
              child: ListView.builder(
                itemCount: kategoriList.length,
                itemBuilder: (context, index) {
                  final kategori = kategoriList[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          getKategoriIcon(kategori['nama_kategori'] ?? ''),
                          color: Colors.green,
                        ),
                      ),
                      title: Text(
                        kategori['nama_kategori'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID Kategori: ${kategori['id']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
