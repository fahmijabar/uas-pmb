import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tambah_bahan_screen.dart';
import 'screens/kategori_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Koolkasku',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Key dashboardKey = UniqueKey();

  void refreshDashboard() {
    setState(() {
      dashboardKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,

      // HEADER
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Koolkasku",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      // BODY
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DashboardScreen(key: dashboardKey),
      ),

      // BUTTON BAWAH
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TAMBAH DATA
          FloatingActionButton(
            heroTag: "btnTambah",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahBahanScreen()),
              );

              if (result == true) {
                refreshDashboard();
              }
            },
          ),

          const SizedBox(width: 20),

          // KATEGORI
          FloatingActionButton(
            heroTag: "btnKategori",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KategoriScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
