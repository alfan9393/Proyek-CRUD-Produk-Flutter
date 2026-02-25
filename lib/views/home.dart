import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/produk_model.dart';
import '../models/api.dart';
import 'create.dart';
import 'edit.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ProdukModel>> produkList;

  @override
  void initState() {
    super.initState();
    produkList = getProdukList();
  }


  String fixImageUrl(String url) {
    if (url.contains("drive.google.com")) {
      final uri = Uri.parse(url);
      if (uri.pathSegments.contains("d")) {
        final fileId = uri.pathSegments[uri.pathSegments.indexOf("d") + 1];
        return "https://drive.google.com/uc?export=view&id=$fileId";
      }
    }
    return url;
  }

  Future<List<ProdukModel>> getProdukList() async {
    final response = await http.get(Uri.parse(BaseUrl.data));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return ProdukModel.fromJsonList(data);
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  Future<void> deleteProduk(int id) async {
    final response = await http.post(
      Uri.parse(BaseUrl.hapus),
      body: {'id': id.toString()},
    );

    final result = json.decode(response.body);

    if (result['status'] == true) {
      setState(() {
        produkList = getProdukList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<ProdukModel>>(
        future: produkList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data produk kosong'));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final produk = data[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      produk.gambar.isNotEmpty
                          ? fixImageUrl(produk.gambar)
                          : "https://picsum.photos/200",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 40);
                      },
                    ),
                  ),
                  title: Text(
                    produk.namaProduk,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kode: ${produk.kodeProduk}'),
                      Text('Harga: Rp ${produk.harga}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility,
                            color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailProdukPage(produk: produk),
                            ),
                          );
                        },
                      ),

                      
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.orange),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditProduk(produk: produk),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              produkList = getProdukList();
                            });
                          }
                        },
                      ),


                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Produk'),
                              content: const Text(
                                  'Yakin ingin menghapus produk ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteProduk(produk.id);
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CreateProduk()),
          );
          if (result == true) {
            setState(() {
              produkList = getProdukList();
            });
          }
        },
      ),
    );
  }
}