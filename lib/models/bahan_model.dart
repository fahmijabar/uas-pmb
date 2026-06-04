class Bahan {
  final String id;
  final String nama;
  final DateTime tanggalMasuk;
  final int masaSimpan;

  Bahan({
    required this.id,
    required this.nama,
    required this.tanggalMasuk,
    required this.masaSimpan,
  });

  // ==========================
  // JSON -> OBJECT
  // ==========================
  factory Bahan.fromJson(Map<String, dynamic> json) {
    return Bahan(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      tanggalMasuk: DateTime.parse(json['tanggal_masuk'].toString()),
      masaSimpan: int.parse(json['masa_simpan'].toString()),
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
      'masa_simpan': masaSimpan.toString(),
    };
  }

  // ==========================
  // ALGORITMA EXPIRED
  // ==========================

  /// tanggal expired otomatis
  DateTime get tanggalExpired {
    return tanggalMasuk.add(Duration(days: masaSimpan));
  }

  /// sisa hari menuju expired
  int get sisaHari {
    final sekarang = DateTime.now();

    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);

    final expired = DateTime(
      tanggalExpired.year,
      tanggalExpired.month,
      tanggalExpired.day,
    );

    return expired.difference(hariIni).inDays;
  }

  /// apakah sudah expired
  bool get isExpired => sisaHari < 0;

  /// status untuk dashboard
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
