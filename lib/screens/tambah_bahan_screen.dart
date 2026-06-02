import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahBahanScreen extends StatefulWidget {
  const TambahBahanScreen({super.key});

  @override
  State<TambahBahanScreen> createState() => _TambahBahanScreenState();
}

class _TambahBahanScreenState extends State<TambahBahanScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? _selectedJenis;
  DateTime? _finalKadaluarsa;

  final List<String> _listJenis = [
    'Makanan Kemasan (Input Manual)',
    'Sayuran (Otomatis 5 Hari)',
    'Buah (Otomatis 7 Hari)',
    'Daging / Ikan (Otomatis 3 Hari)',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _finalKadaluarsa = picked;
        _tanggalController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime waktuHitungSistem = DateTime.now();

    int masaSimpan = 0;

    if (_selectedJenis == 'Makanan Kemasan (Input Manual)') {
      waktuHitungSistem = _finalKadaluarsa!;
      masaSimpan =
          _finalKadaluarsa!.difference(DateTime.now()).inDays;
    } else if (_selectedJenis == 'Sayuran (Otomatis 5 Hari)') {
      masaSimpan = 5;
      waktuHitungSistem = waktuHitungSistem.add(const Duration(days: 5));
    } else if (_selectedJenis == 'Buah (Otomatis 7 Hari)') {
      masaSimpan = 7;
      waktuHitungSistem = waktuHitungSistem.add(const Duration(days: 7));
    } else if (_selectedJenis == 'Daging / Ikan (Otomatis 3 Hari)') {
      masaSimpan = 3;
      waktuHitungSistem = waktuHitungSistem.add(const Duration(days: 3));
    }

    String tanggalMasuk =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2/api_kulkas/insert.php"),
        body: {
          "nama": _namaController.text,
          "tanggal_masuk": tanggalMasuk,
          "masa_simpan": masaSimpan.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil! ${_namaController.text} disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // kembali ke dashboard
      } else {
        throw Exception("Gagal simpan");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Bahan Makanan'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bahan',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedJenis,
                  hint: const Text("Pilih jenis"),
                  items: _listJenis.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedJenis = val;
                      _tanggalController.clear();
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Pilih jenis' : null,
                ),

                const SizedBox(height: 16),

                if (_selectedJenis ==
                    'Makanan Kemasan (Input Manual)')
                  TextFormField(
                    controller: _tanggalController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Kadaluarsa',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _pilihTanggal(context),
                    validator: (value) =>
                        value!.isEmpty ? 'Wajib isi tanggal' : null,
                  ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _simpanData,
                  child: const Text("Simpan"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}