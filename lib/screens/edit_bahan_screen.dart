import 'package:flutter/material.dart';
import '../services/api_services.dart';

class EditBahanScreen extends StatefulWidget {
  final String id;
  final String nama;
  final String tanggalMasuk;
  final String masaSimpan;

  const EditBahanScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.tanggalMasuk,
    required this.masaSimpan,
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

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.nama);
    tanggalController = TextEditingController(text: widget.tanggalMasuk);
    masaSimpanController = TextEditingController(text: widget.masaSimpan);
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
      initialDate = DateTime.parse(tanggalController.text);
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

    print("ID : ${widget.id}");
    print("NAMA : ${namaController.text}");
    print("TANGGAL : ${tanggalController.text}");
    print("MASA SIMPAN : ${masaSimpanController.text}");

    bool success = await ApiService().updateBahan(
      id: widget.id,
      nama: namaController.text.trim(),
      tanggalMasuk: tanggalController.text.trim(),
      masaSimpan: masaSimpanController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil diupdate"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal update data"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  if (value == null || value.trim().isEmpty) {
                    return "Nama bahan wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tanggalController,
                readOnly: true,
                onTap: pilihTanggal,
                decoration: const InputDecoration(
                  labelText: "Tanggal Masuk",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tanggal masuk wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: masaSimpanController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Masa Simpan (Hari)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masa simpan wajib diisi";
                  }

                  if (int.tryParse(value) == null) {
                    return "Harus berupa angka";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "UPDATE DATA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
