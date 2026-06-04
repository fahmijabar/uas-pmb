import 'package:flutter/material.dart';
import '../services/api_services.dart';

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
  bool isLoading = false;

  final List<String> _listJenis = [
    'Makanan Kemasan (Input Manual)',
    'Minuman Kemasan (Input Manual)',
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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _finalKadaluarsa = picked;

        _tanggalController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    int masaSimpan = 0;

    if (_selectedJenis == 'Makanan Kemasan (Input Manual)' ||
        _selectedJenis == 'Minuman Kemasan (Input Manual)') {
      masaSimpan = _finalKadaluarsa!.difference(DateTime.now()).inDays + 1;

      if (masaSimpan <= 0) {
        masaSimpan = 1;
      }
    } else if (_selectedJenis == 'Sayuran (Otomatis 5 Hari)') {
      masaSimpan = 5;
    } else if (_selectedJenis == 'Buah (Otomatis 7 Hari)') {
      masaSimpan = 7;
    } else if (_selectedJenis == 'Daging / Ikan (Otomatis 3 Hari)') {
      masaSimpan = 3;
    }

    String tanggalMasuk = DateTime.now().toString().split(' ')[0];

    bool sukses = await ApiService().insertBahan(
      nama: _namaController.text.trim(),
      tanggalMasuk: tanggalMasuk,
      masaSimpan: masaSimpan.toString(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil disimpan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Bahan"),
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
                    labelText: "Nama Bahan",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama bahan wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Jumlah",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: _selectedJenis,
                  decoration: const InputDecoration(
                    labelText: "Jenis Bahan",
                    border: OutlineInputBorder(),
                  ),
                  items: _listJenis.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedJenis = value;

                      if (value != 'Makanan Kemasan (Input Manual)' &&
                          value != 'Minuman Kemasan (Input Manual)') {
                        _tanggalController.clear();
                        _finalKadaluarsa = null;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Pilih jenis bahan";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                if (_selectedJenis == 'Makanan Kemasan (Input Manual)' ||
                    _selectedJenis == 'Minuman Kemasan (Input Manual)')
                  TextFormField(
                    controller: _tanggalController,
                    readOnly: true,
                    onTap: () => _pilihTanggal(context),
                    decoration: const InputDecoration(
                      labelText: "Tanggal Kadaluarsa",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tanggal kadaluarsa wajib dipilih";
                      }
                      return null;
                    },
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Simpan ke Kulkas",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
