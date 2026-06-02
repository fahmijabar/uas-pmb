import 'package:flutter/material.dart';

class TambahBahanScreen extends StatefulWidget {
  const TambahBahanScreen({super.key});

  @override
  State<TambahBahanScreen> createState() => _TambahBahanScreenState();
}

class _TambahBahanScreenState extends State<TambahBahanScreen> {
  // 1. Kunci untuk mendeteksi validasi Form
  final _formKey = GlobalKey<FormState>();

  // 2. Controller untuk mengambil teks inputan
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController =
      TextEditingController(); // Controller Baru

  // 3. State Tambahan untuk Jenis dan Tanggal Kadaluarsa
  String? _selectedJenis;
  DateTime? _finalKadaluarsa;

  // Daftar pilihan Jenis Bahan Makanan
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
    _tanggalController.dispose(); // Di-dispose agar tidak leak
    super.dispose();
  }

  // Fungsi pembantu untuk memunculkan Kalender (Date Picker)
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Tidak bisa pilih tanggal kemarin
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _finalKadaluarsa = picked;
        // Mengubah format tanggal untuk ditampilkan di kotak form
        _tanggalController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Ditambah agar layar bisa di-scroll jika keyboard muncul
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- INPUT NAMA BAHAN ---
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bahan Makanan',
                    hintText: 'Contoh: Wortel, Ayam, Susu',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama bahan tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- INPUT JUMLAH ---
                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah / Stok',
                    hintText: 'Contoh: 5',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Jumlah tidak boleh kosong!';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Harus berupa angka bulat!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- NEW: DROPDOWN PILIHAN JENIS ---
                DropdownButtonFormField<String>(
                  initialValue: _selectedJenis,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Bahan Makanan',
                  ),
                  hint: const Text('Pilih jenis bahan'),
                  items: _listJenis.map((String jenis) {
                    return DropdownMenuItem<String>(
                      value: jenis,
                      child: Text(jenis),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedJenis = value;
                      // Reset tanggal manual jika user pindah ke jenis otomatis
                      if (_selectedJenis != 'Makanan Kemasan (Input Manual)') {
                        _tanggalController.clear();
                        _finalKadaluarsa = null;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Silakan pilih jenis bahan makanan!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- NEW: LOGIKA FORM TANGGAL KADALUARSA ---
                // Jika memilih Makanan Kemasan, WAJIB input tanggal manual
                if (_selectedJenis == 'Makanan Kemasan (Input Manual)') ...[
                  TextFormField(
                    controller: _tanggalController,
                    readOnly:
                        true, // Supaya keyboard tidak muncul, diganti ketukan kalender
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Kadaluarsa',
                      hintText: 'Ketuk untuk memilih tanggal',
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.teal,
                      ),
                    ),
                    onTap: () => _pilihTanggal(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal kadaluarsa wajib diisi untuk makanan kemasan!';
                      }
                      return null;
                    },
                  ),
                ]
                // Jika memilih Sayur/Buah/Daging, tampilkan info otomatis dari sistem
                else if (_selectedJenis != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.teal),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sistem akan otomatis menghitung mundur waktu kadaluarsa untuk jenis bahan ini.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // --- TOMBOL SIMPAN ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // LOGIKA SISTEM: Hitung otomatis Tanggal Kadaluarsa berdasarkan poin 1 & 2
                        DateTime waktuHitungSistem = DateTime.now();

                        if (_selectedJenis ==
                            'Makanan Kemasan (Input Manual)') {
                          // Poin 1: Menggunakan tanggal yang diinput sendiri oleh user
                          waktuHitungSistem = _finalKadaluarsa!;
                        } else if (_selectedJenis ==
                            'Sayuran (Otomatis 5 Hari)') {
                          // Poin 2: Sistem otomatis menambah 5 hari
                          waktuHitungSistem = waktuHitungSistem.add(
                            const Duration(days: 5),
                          );
                        } else if (_selectedJenis == 'Buah (Otomatis 7 Hari)') {
                          // Poin 2: Sistem otomatis menambah 7 hari
                          waktuHitungSistem = waktuHitungSistem.add(
                            const Duration(days: 7),
                          );
                        } else if (_selectedJenis ==
                            'Daging / Ikan (Otomatis 3 Hari)') {
                          // Poin 2: Sistem otomatis menambah 3 hari
                          waktuHitungSistem = waktuHitungSistem.add(
                            const Duration(days: 3),
                          );
                        }

                        // Mengubah format untuk pembacaan info sukses
                        String tglFix =
                            "${waktuHitungSistem.day}/${waktuHitungSistem.month}/${waktuHitungSistem.year}";

                        // Memunculkan Notifikasi Hasil Pengujian Offline
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Sukses! ${_namaController.text} (${_selectedJenis!.split(" ")[0]}) '
                              'Kadaluarsa pada: $tglFix',
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 4),
                          ),
                        );

                        // INFO TIM: Variabel 'waktuHitungSistem' inilah yang nanti dikirim ke internet/PHP.
                      }
                    },
                    child: const Text(
                      'Simpan ke Kulkas',
                      style: TextStyle(color: Colors.white),
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
