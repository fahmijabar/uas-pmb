import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../services/api_services.dart';
=======
import 'package:http/http.dart' as http;
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05

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
<<<<<<< HEAD
      lastDate: DateTime(2035),
=======
      lastDate: DateTime(2030),
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
    );

    if (picked != null) {
      setState(() {
        _finalKadaluarsa = picked;
<<<<<<< HEAD

=======
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
        _tanggalController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

<<<<<<< HEAD
  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });
=======
  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime waktuHitungSistem = DateTime.now();
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05

    int masaSimpan = 0;

    if (_selectedJenis == 'Makanan Kemasan (Input Manual)') {
<<<<<<< HEAD
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
=======
      waktuHitungSistem = _finalKadaluarsa!;
      masaSimpan = _finalKadaluarsa!.difference(DateTime.now()).inDays;
    } else if (_selectedJenis == 'Minuman Kemasan (Input Manual)') {
      waktuHitungSistem = _finalKadaluarsa!;
      masaSimpan = _finalKadaluarsa!.difference(DateTime.now()).inDays;
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
        Uri.parse("http://localhost/api_kulkas/create.php"),
        body: {
          "nama": _namaController.text,
          "tanggal_masuk": tanggalMasuk,
          "masa_simpan": masaSimpan.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil! ${_namaController.text} disimpan'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // kembali ke dashboard
      } else {
        throw Exception("Gagal simpan");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
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
<<<<<<< HEAD
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

                      if (value != 'Makanan Kemasan (Input Manual)') {
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

                if (_selectedJenis == 'Makanan Kemasan (Input Manual)')
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
=======
                  decoration: const InputDecoration(labelText: 'Nama Bahan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedJenis,
                  hint: const Text("Pilih jenis"),
                  items: _listJenis.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedJenis = val;
                      _tanggalController.clear();
                    });
                  },
                  validator: (value) => value == null ? 'Pilih jenis' : null,
                ),

                const SizedBox(height: 16),

                if (_selectedJenis == 'Makanan Kemasan (Input Manual)' ||
                    _selectedJenis == 'Minuman Kemasan (Input Manual)')
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
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
                  ),

                const SizedBox(height: 30),

<<<<<<< HEAD
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
=======
                ElevatedButton(
                  onPressed: _simpanData,
                  child: const Text("Simpan"),
>>>>>>> 85ff7d9dcfd194849ca9378ca9bab21f76904b05
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
