import 'package:flutter/material.dart';
import '../models/bahan_model.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Bahan>> futureBahan;

  @override
  void initState() {
    super.initState();
    futureBahan = ApiService().getBahan();
  }

  Color getWarna(int sisaHari) {
    if (sisaHari < 0) return Colors.red;
    if (sisaHari <= 2) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bahan>>(
      future: futureBahan,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data"));
        }

        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final bahan = data[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              padding: const EdgeInsets.all(10),
              color: Colors.grey[300],
              child: Row(
                children: [
                  // 🔹 ICON BULAT (ID)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Text(
                      bahan.id,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 🔹 DATA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bahan.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("tanggal masuk: ${bahan.tanggalMasukFormat}"),
                        Text("tanggal expired: ${bahan.tanggalExpiredFormat}"),
                        Text("sisa hari: ${bahan.sisaHari}"),
                      ],
                    ),
                  ),

                  // 🔹 STATUS
                  Text(
                    bahan.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getWarna(bahan.sisaHari),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}