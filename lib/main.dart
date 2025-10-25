import 'package:flutter/material.dart';
import 'package:pertemuan4/API/api_service.dart';
import 'package:pertemuan4/Model/article_model.dart';

void main() {
  runApp(const DaftarBerita());
}

class DaftarBerita extends StatelessWidget {
  const DaftarBerita({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TampilanDaftarBerita(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TampilanDaftarBerita extends StatefulWidget {
  const TampilanDaftarBerita({super.key});

  @override
  State<TampilanDaftarBerita> createState() => _TampilanDaftarBeritaState();
}

class _TampilanDaftarBeritaState extends State<TampilanDaftarBerita> {
  late Future<List<Article>> _articles;
  final ScrollController _scrollcontrol = ScrollController();
  bool _ScrollTopButton = false;

  @override
  void initState() {
    super.initState();
    _articles = ApiService().fetchArticles();

    _scrollcontrol.addListener(() {
      setState(() {
        _ScrollTopButton = _scrollcontrol.position.pixels > 150;
      });
    });
  }

  @override
  void dispose() {
    _scrollcontrol.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _articles = ApiService().fetchArticles();
    });
  }

  void _scrollToTop() {
    _scrollcontrol.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salman Berita Terkini"),
        backgroundColor: Colors.green,
      ),

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 6),
            const Text(
              "LIST BERITA TERBARU",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _articles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final newsList = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        controller: _scrollcontrol,
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          final artikel = newsList[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              leading: (artikel.urlToImage != null)
                                  ? Image.network(
                                      artikel.urlToImage!,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                              title: Text(
                                artikel.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                artikel.description ?? "Deskripsi Tidak Ada.",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("Berita Tidak Ada.");
                  }
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: _ScrollTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.green,
              child: const Icon(Icons.arrow_upward_outlined),
            )
          : null,
    );
  }
}
