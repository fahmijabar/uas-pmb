class Bahan {
  final String id;
  final String nama;
  final int jumlah;
  final DateTime tanggalMasuk;
  final int masaSimpan;

  final int kategoriId;

  final String? kategoriNama;

  Bahan({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.masaSimpan,
    required this.kategoriId,
    this.kategoriNama,
  });

  factory Bahan.fromJson(Map<String, dynamic> json) {
    return Bahan(
      id: json['id'].toString(),

      nama: json['nama'] ?? '',

      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,

      tanggalMasuk: DateTime.parse(json['tanggal_masuk'].toString()),

      masaSimpan: int.tryParse(json['masa_simpan'].toString()) ?? 0,

      kategoriId: json['kategori_id'] ?? 0,

      kategoriNama: json['kategori'] != null
          ? json['kategori']['nama'].toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasukFormat,
      'masa_simpan': masaSimpan,
      'kategori_id': kategoriId,
    };
  }

  DateTime get tanggalExpired {
    return tanggalMasuk.add(Duration(days: masaSimpan));
  }

  int get sisaHari {
    final now = DateTime.now();

    final hariIni = DateTime(now.year, now.month, now.day);

    final expired = DateTime(
      tanggalExpired.year,
      tanggalExpired.month,
      tanggalExpired.day,
    );

    return expired.difference(hariIni).inDays;
  }

  String get status {
    if (sisaHari < 0) {
      return "Expired";
    } else if (sisaHari <= 2) {
      return "Segera Expired";
    } else {
      return "Aman";
    }
  }

  String get tanggalMasukFormat {
    return "${tanggalMasuk.year}-${tanggalMasuk.month.toString().padLeft(2, '0')}-${tanggalMasuk.day.toString().padLeft(2, '0')}";
  }

  String get tanggalExpiredFormat {
    return "${tanggalExpired.year}-${tanggalExpired.month.toString().padLeft(2, '0')}-${tanggalExpired.day.toString().padLeft(2, '0')}";
  }
}
