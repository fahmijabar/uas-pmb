import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BahanKategoriScreen extends StatefulWidget {
  final int kategoriId;
  final String namaKategori;

  const BahanKategoriScreen({
    super.key,
    required this.kategoriId,
    required this.namaKategori,
  });

  @override
  State<BahanKategoriScreen> createState() => _BahanKategoriScreenState();
}

class _BahanKategoriScreenState extends State<BahanKategoriScreen> {
  final supabase = Supabase.instance.client;

  List bahanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBahanKategori();
  }

  Future<void> getBahanKategori() async {
    try {
      final data = await supabase
          .from('bahan')
          .select()
          .eq('kategori_id', widget.kategoriId);

      setState(() {
        bahanList = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.namaKategori)),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bahanList.isEmpty
          ? const Center(child: Text("Tidak ada bahan pada kategori ini"))
          : ListView.builder(
              itemCount: bahanList.length,
              itemBuilder: (context, index) {
                final bahan = bahanList[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.kitchen),

                    title: Text(bahan['nama']),

                    subtitle: Text(
                      "Masa Simpan : ${bahan['masa_simpan']} hari",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
