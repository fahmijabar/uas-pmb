class Bahan {
  final String id;
  final String nama;
  final DateTime tanggalMasuk;
  final int masaSimpan;

  // Foreign Key
  final int kategoriId;

  // Nama kategori (opsional)
  final String? kategoriNama;

  Bahan({
    required this.id,
    required this.nama,
    required this.tanggalMasuk,
    required this.masaSimpan,
    required this.kategoriId,
    this.kategoriNama,
  });

  // ==========================
  // JSON -> OBJECT
  // ==========================
  factory Bahan.fromJson(Map<String, dynamic> json) {
    return Bahan(
      id: json['id'].toString(),

      nama: json['nama'] ?? '',

      tanggalMasuk: DateTime.parse(
        json['tanggal_masuk'].toString(),
      ),

      masaSimpan: int.tryParse(
            json['masa_simpan'].toString(),
          ) ??
          0,

      kategoriId: json['kategori_id'] ?? 0,

      kategoriNama: json['kategori'] != null
          ? json['kategori']['nama'].toString()
          : null,
    );
  }

  // ==========================
  // OBJECT -> JSON
  // ==========================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'tanggal_masuk': tanggalMasukFormat,
      'masa_simpan': masaSimpan,
      'kategori_id': kategoriId,
    };
  }

  // ==========================
  // ALGORITMA EXPIRED
  // ==========================

  /// tanggal expired
  DateTime get tanggalExpired {
    return tanggalMasuk.add(
      Duration(days: masaSimpan),
    );
  }

  /// sisa hari
  int get sisaHari {
    final now = DateTime.now();

    final hariIni = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final expired = DateTime(
      tanggalExpired.year,
      tanggalExpired.month,
      tanggalExpired.day,
    );

    return expired.difference(hariIni).inDays;
  }

  /// status bahan
  String get status {
    if (sisaHari < 0) {
      return "Expired";
    } else if (sisaHari <= 2) {
      return "Segera Habis";
    } else {
      return "Aman";
    }
  }

  // ==========================
  // FORMAT TANGGAL
  // ==========================

  String get tanggalMasukFormat {
    return "${tanggalMasuk.year}-${tanggalMasuk.month.toString().padLeft(2, '0')}-${tanggalMasuk.day.toString().padLeft(2, '0')}";
  }

  String get tanggalExpiredFormat {
    return "${tanggalExpired.year}-${tanggalExpired.month.toString().padLeft(2, '0')}-${tanggalExpired.day.toString().padLeft(2, '0')}";
  }
}