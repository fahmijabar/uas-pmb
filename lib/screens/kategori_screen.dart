import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bahan_kategori_screen.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final supabase = Supabase.instance.client;

  List kategoriList = [];
  bool isLoading = true;

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
      final data = await supabase
          .from('kategori')
          .select();

      print("DATA DARI SUPABASE:");
      print(data);

      setState(() {
        kategoriList = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR GET KATEGORI:");
      print(e);

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
      await supabase.from('kategori').insert({
        'nama': namaKategori,
      });

      await getKategori();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kategori berhasil ditambahkan"),
        ),
      );
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
      final response = await supabase
          .from('kategori')
          .update({
            'nama': namaKategori,
          })
          .eq('id', int.parse(id))
          .select();

      print("HASIL UPDATE:");
      print(response);

      await getKategori();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kategori berhasil diubah"),
          ),
        );
      }
    } catch (e) {
      print("ERROR UPDATE:");
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal update: $e"),
        ),
      );
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<void> hapusKategori(String id) async {
    try {
      await supabase
          .from('kategori')
          .delete()
          .eq('id', int.parse(id));

      await getKategori();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kategori berhasil dihapus"),
        ),
      );
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
  void showEditDialog(String id, String namaKategori) {
    TextEditingController controller = TextEditingController(
      text: namaKategori,
    );

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
              onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {

                    await updateKategori(
                      id,
                      controller.text.trim(),
                    );

                    if (mounted) {
                      Navigator.pop(context);
                    }
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
  // DIALOG HAPUS
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
      appBar: AppBar(
        title: const Text("Kategori Bahan"),
        centerTitle: true,
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btnTambahKategori",
        backgroundColor: Colors.blue,
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
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BahanKategoriScreen(
                                  kategoriId: kategori['id'],
                                  namaKategori: kategori['nama'],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            kategori['nama'],
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
                                    kategori['nama'],
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
    );
  }
}