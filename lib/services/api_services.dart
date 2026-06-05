import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bahan_model.dart';

class ApiService {
  final supabase = Supabase.instance.client;

  // ==========================
  // READ
  // ==========================
  Future<List<Bahan>> getBahan() async {
    try {
      final data = await supabase
          .from('bahan')
          .select('''
            *,
            kategori (
              id,
              nama
            )
          ''')
          .order('id');

      return (data as List)
          .map((e) => Bahan.fromJson(e))
          .toList();
    } catch (e) {
      print("ERROR READ : $e");
      return [];
    }
  }

  // ==========================
  // INSERT
  // ==========================
  Future<bool> insertBahan({
    required String nama,
    required String tanggalMasuk,
    required String masaSimpan,
    required int kategoriId,
  }) async {
    try {
      await supabase.from('bahan').insert({
        'nama': nama,
        'tanggal_masuk': tanggalMasuk,
        'masa_simpan': int.parse(masaSimpan),
        'kategori_id': kategoriId,
      });

      return true;
    } catch (e) {
      print("ERROR INSERT : $e");
      return false;
    }
  }

  // ==========================
  // UPDATE
  // ==========================
  Future<bool> updateBahan({
    required String id,
    required String nama,
    required String tanggalMasuk,
    required String masaSimpan,
    required int kategoriId,
  }) async {
    try {
      await supabase
          .from('bahan')
          .update({
            'nama': nama,
            'tanggal_masuk': tanggalMasuk,
            'masa_simpan': int.parse(masaSimpan),
            'kategori_id': kategoriId,
          })
          .eq('id', int.parse(id));

      return true;
    } catch (e) {
      print("ERROR UPDATE : $e");
      return false;
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<bool> deleteBahan(String id) async {
    try {
      await supabase
          .from('bahan')
          .delete()
          .eq('id', int.parse(id));

      return true;
    } catch (e) {
      print("ERROR DELETE : $e");
      return false;
    }
  }

  // ==========================
  // FILTER BERDASARKAN KATEGORI
  // ==========================
  Future<List<Bahan>> getBahanByKategori(
    int kategoriId,
  ) async {
    try {
      final data = await supabase
          .from('bahan')
          .select('''
            *,
            kategori (
              id,
              nama
            )
          ''')
          .eq('kategori_id', kategoriId)
          .order('id');

      return (data as List)
          .map((e) => Bahan.fromJson(e))
          .toList();
    } catch (e) {
      print("ERROR FILTER : $e");
      return [];
    }
  }
}