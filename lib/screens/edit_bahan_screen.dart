import 'package:flutter/material.dart';
import '../services/api_services.dart';

class EditBahanScreen extends StatefulWidget {
  final String id;
  final String nama;
  final String tanggalMasuk;
  final String masaSimpan;
  final int kategoriId;

  const EditBahanScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.tanggalMasuk,
    required this.masaSimpan,
    required this.kategoriId,
  });

  @override
  State<EditBahanScreen> createState() => _EditBahanScreenState();
}

class _EditBahanScreenState extends State<EditBahanScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController tanggalController;
  late TextEditingController masaSimpanController;

  bool isLoading = false;

  String? selectedJenis;
  int kategoriId = 0;

  final List<String> listJenis = [
    'Sayuran (Otomatis 5 Hari)',
    'Buah (Otomatis 7 Hari)',
    'Daging / Ikan (Otomatis 3 Hari)',
    'Makanan Kemasan (Input Manual)',
    'Minuman Kemasan (Input Manual)',
  ];

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(text: widget.nama);

    tanggalController =
        TextEditingController(text: widget.tanggalMasuk);

    masaSimpanController =
        TextEditingController(text: widget.masaSimpan);

    kategoriId = widget.kategoriId;

    switch (widget.kategoriId) {
      case 1:
        selectedJenis = 'Sayuran (Otomatis 5 Hari)';
        break;

      case 2:
        selectedJenis = 'Buah (Otomatis 7 Hari)';
        break;

      case 3:
        selectedJenis = 'Daging / Ikan (Otomatis 3 Hari)';
        break;

      case 4:
        selectedJenis = 'Minuman Kemasan (Input Manual)';
        break;

      case 5:
        selectedJenis = 'Makanan Kemasan (Input Manual)';
        break;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    tanggalController.dispose();
    masaSimpanController.dispose();
    super.dispose();
  }

  Future<void> pilihTanggal() async {
    DateTime initialDate;

    try {
      initialDate = DateTime.parse(
        tanggalController.text,
      );
    } catch (_) {
      initialDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      tanggalController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      setState(() {});
    }
  }

  Future<void> updateData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    bool success = await ApiService().updateBahan(
      id: widget.id,
      nama: namaController.text.trim(),
      tanggalMasuk: tanggalController.text.trim(),
      masaSimpan: masaSimpanController.text.trim(),
      kategoriId: kategoriId,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil diupdate"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal update data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void ubahKategori(String? value) {
    setState(() {
      selectedJenis = value;

      if (value == 'Sayuran (Otomatis 5 Hari)') {
        kategoriId = 1;
      } 
      else if (value == 'Buah (Otomatis 7 Hari)') {
        kategoriId = 2;
      } 
      else if (value == 'Daging / Ikan (Otomatis 3 Hari)') {
        kategoriId = 3;
      } 
      else if (value == 'Minuman Kemasan (Input Manual)') {
        kategoriId = 4;
      } 
      else if (value == 'Makanan Kemasan (Input Manual)') {
        kategoriId = 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Bahan"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Bahan",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Nama bahan wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedJenis,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                items: listJenis.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: ubahKategori,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tanggalController,
                readOnly: true,
                onTap: pilihTanggal,
                decoration: const InputDecoration(
                  labelText: "Tanggal Masuk",
                  border: OutlineInputBorder(),
                  suffixIcon:
                      Icon(Icons.calendar_month),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: masaSimpanController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Masa Simpan (Hari)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Masa simpan wajib diisi";
                  }

                  if (int.tryParse(value) ==
                      null) {
                    return "Harus berupa angka";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "UPDATE DATA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}