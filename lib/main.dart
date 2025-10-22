import 'package:flutter/material.dart';
import 'package:pertemuan4/API/makananApi.dart';
import 'package:pertemuan4/Model/makanan_model.dart';

void main() {
  runApp(DaftarMakanan());
}

//tampilan dasarannya dulu
//MaterialApp & Scaffold

class DaftarMakanan extends StatelessWidget {
  const DaftarMakanan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TampilanDaftarMakanan(), //untuk memanggil scaffold
      debugShowCheckedModeBanner: false,
    );
  }
}

class TampilanDaftarMakanan extends StatefulWidget {
  const TampilanDaftarMakanan({super.key});

  @override
  State<TampilanDaftarMakanan> createState() => _TampilanDaftarMakananState();
}

class _TampilanDaftarMakananState extends State<TampilanDaftarMakanan> {
  late Future<List<Makanan>> _makanan;

  // Tambahan:
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  //untuk menjalankan fungsi mengambil datanya
  @override
  void initState() {
    super.initState();
    _makanan = ApiService().fetchMakanan();

    //fungsi Kembali ke atas
    _scrollController.addListener(() {
      if (_scrollController.offset >= 100) {
        setState(() => _showBackToTopButton = true);
      } else {
        setState(() => _showBackToTopButton = false);
      }
    });
  }

  // Fungsi refresh data
  Future<void> _refreshData() async {
    setState(() {
      _makanan = ApiService().fetchMakanan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Makanan di Restoran Salman"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "List Menu Makanan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            //Disini Kita Akan Tampilkan Menu Makanannya yang datanya didapat dari API
            Expanded(
              child: FutureBuilder(
                future: _makanan,
                builder: (context, snapshot) {
                  //datanya ada
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final makanans = snapshot.data!;
                    // Tambahkan RefreshIndicator di sini
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        controller: _scrollController, // Tambahan controller
                        itemCount: makanans.length,
                        itemBuilder: (context, index) {
                          final makanan = makanans[index]; //index
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              leading: Image(image: NetworkImage(makanan.img!)),
                              title: Text(makanan.nama!),
                              subtitle: Text(makanan.rangking!),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  //datanya erro
                  else {
                    return Text("Data Eror");
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // Tombol kembali ke atas
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
