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

  // GANTI URL SESUAI SERVER ANDA
  final String baseUrl = "http://localhost/api_kulkas";

  @override
  void initState() {
    super.initState();
    getKategori();
  }

  // ==========================
  // READ
  // ==========================
  Future<void> getKategori() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
<<<<<<< HEAD
        Uri.parse('http://localhost/api_kulkas/read_kategori.php'),
=======
        Uri.parse("$baseUrl/get_kategori.php"),
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
      );

      print("STATUS KATEGORI : ${response.statusCode}");
      print("BODY KATEGORI : ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          kategoriList = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR KATEGORI : $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // ==========================
  // CREATE
  // ==========================
  Future<void> tambahKategori(String namaKategori) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tambah_kategori.php"),
        body: {
          "nama_kategori": namaKategori,
        },
      );

      if (response.statusCode == 200) {
        getKategori();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kategori berhasil ditambahkan"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // ==========================
  // UPDATE
  // ==========================
  Future<void> updateKategori(
    String id,
    String namaKategori,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_kategori.php"),
        body: {
          "id": id,
          "nama_kategori": namaKategori,
        },
      );

      if (response.statusCode == 200) {
        getKategori();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kategori berhasil diubah"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<void> hapusKategori(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/hapus_kategori.php"),
        body: {
          "id": id,
        },
      );

      if (response.statusCode == 200) {
        getKategori();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kategori berhasil dihapus"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // ==========================
  // DIALOG TAMBAH
  // ==========================
  void showTambahDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Kategori"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Nama Kategori",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  tambahKategori(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // ==========================
  // DIALOG EDIT
  // ==========================
  void showEditDialog(
    String id,
    String namaKategori,
  ) {
    TextEditingController controller =
        TextEditingController(text: namaKategori);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Kategori"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  updateKategori(id, controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // ==========================
  // KONFIRMASI HAPUS
  // ==========================
  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Kategori"),
          content: const Text(
            "Apakah Anda yakin ingin menghapus kategori ini?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                hapusKategori(id);
                Navigator.pop(context);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  IconData getKategoriIcon(String nama) {
    switch (nama.toLowerCase()) {
      case "sayuran":
        return Icons.eco;

      case "buah":
        return Icons.apple;

      case "daging":
        return Icons.set_meal;

      case "minuman":
        return Icons.local_drink;

      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
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
=======
      appBar: AppBar(
        title: const Text("Kategori Bahan"),
        centerTitle: true,
      ),

      // Tombol tambah kategori
      floatingActionButton: FloatingActionButton(
        onPressed: showTambahDialog,
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : kategoriList.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada kategori",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: getKategori,
                  child: ListView.builder(
                    itemCount: kategoriList.length,
                    itemBuilder: (context, index) {
                      final kategori = kategoriList[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              getKategoriIcon(
                                kategori['nama_kategori'],
                              ),
                            ),
                          ),
                          title: Text(
                            kategori['nama_kategori'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "ID : ${kategori['id']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  showEditDialog(
                                    kategori['id'].toString(),
                                    kategori['nama_kategori'],
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDeleteDialog(
                                    kategori['id'].toString(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
    );
  }
}
