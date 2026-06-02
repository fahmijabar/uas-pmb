class Bahan {
  final String id;
  final String nama;
  final DateTime tanggalMasuk;
  final int masaSimpan; // dalam hari

  Bahan({
    required this.id,
    required this.nama,
    required this.tanggalMasuk,
    required this.masaSimpan,
  });

  // CONVERT JSON → OBJECT
  factory Bahan.fromJson(Map<String, dynamic> json) {
    return Bahan(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      tanggalMasuk: DateTime.parse(json['tanggal_masuk']),
      masaSimpan: int.parse(json['masa_simpan'].toString()),
    );
  }

  // ===============================
  // 🔁 CONVERT OBJECT → JSON
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'tanggal_masuk': tanggalMasuk.toIso8601String(),
      'masa_simpan': masaSimpan.toString(),
    };
  }

  // ===============================
  // 🧠 LOGIKA EXPIRED
  // ===============================

  /// Hitung tanggal expired
  DateTime get tanggalExpired {
    return tanggalMasuk.add(Duration(days: masaSimpan));
  }

  /// Hitung sisa hari sebelum expired
  int get sisaHari {
    final sekarang = DateTime.now();
    return tanggalExpired.difference(sekarang).inDays;
  }

  /// Cek apakah sudah expired
  bool get isExpired {
    return sisaHari < 0;
  }

  /// Status bahan (untuk UI)
  String get status {
    if (sisaHari < 0) {
      return "Expired";
    } else if (sisaHari <= 2) {
      return "Segera habis";
    } else {
      return "Aman";
    }
  }

  /// Warna indikator (opsional untuk UI)
  String get statusColor {
    if (sisaHari < 0) {
      return "red";
    } else if (sisaHari <= 2) {
      return "orange";
    } else {
      return "green";
    }
  }

  // ===============================
  // 🛠 FORMAT TANGGAL (BANTUAN UI)
  // ===============================

  String get tanggalMasukFormat {
    return "${tanggalMasuk.year}-${tanggalMasuk.month.toString().padLeft(2, '0')}-${tanggalMasuk.day.toString().padLeft(2, '0')}";
  }

  String get tanggalExpiredFormat {
    return "${tanggalExpired.year}-${tanggalExpired.month.toString().padLeft(2, '0')}-${tanggalExpired.day.toString().padLeft(2, '0')}";
  }
}