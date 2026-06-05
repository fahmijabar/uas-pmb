import 'package:flutter/material.dart';
import '../models/bahan_model.dart';
import '../services/api_services.dart';
import 'edit_bahan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Bahan>> futureBahan;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    futureBahan = ApiService().getBahan();
  }

  Color getWarna(int sisaHari) {
    if (sisaHari < 0) return Colors.red;
    if (sisaHari <= 2) return Colors.orange;
    return Colors.green;
  }

  Future<void> hapusData(String id) async {
    bool sukses = await ApiService().deleteBahan(id);

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil dihapus"),
        ),
      );

      setState(() {
        loadData();
      });
    }
  }

  Future<void> refreshData() async {
    setState(() {
      loadData();
    });

    await futureBahan;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bahan>>(
      future: futureBahan,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error : ${snapshot.error}",
            ),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Tidak ada data"),
          );
        }

        final data = snapshot.data!;

        return RefreshIndicator(
          onRefresh: refreshData,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final bahan = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      bahan.id,
                    ),
                  ),

                  title: Text(
                    bahan.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),

                      Text(
                        "Tanggal Masuk : ${bahan.tanggalMasukFormat}",
                      ),

                      Text(
                        "Tanggal Expired : ${bahan.tanggalExpiredFormat}",
                      ),

                      Text(
                        "Sisa Hari : ${bahan.sisaHari}",
                      ),

                      Text(
                        "Kategori : ${bahan.kategoriNama ?? '-'}",
                      ),

                      Text(
                        bahan.status,
                        style: TextStyle(
                          color: getWarna(
                            bahan.sisaHari,
                          ),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  trailing: SizedBox(
                    width: 90,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            final result =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditBahanScreen(
                                  id: bahan.id,
                                  nama: bahan.nama,
                                  tanggalMasuk:
                                      bahan.tanggalMasukFormat,
                                  masaSimpan:
                                      bahan.masaSimpan.toString(),

                                  // ambil kategori asli dari database
                                  kategoriId:
                                      bahan.kategoriId,
                                ),
                              ),
                            );

                            if (result == true) {
                              setState(() {
                                loadData();
                              });
                            }
                          },
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(
                                title: const Text(
                                  "Hapus Data",
                                ),
                                content: Text(
                                  "Yakin ingin menghapus ${bahan.nama}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context),
                                    child: const Text(
                                      "Batal",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context);
                                      hapusData(
                                          bahan.id);
                                    },
                                    child: const Text(
                                      "Hapus",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}