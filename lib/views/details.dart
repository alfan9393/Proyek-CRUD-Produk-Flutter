import 'package:flutter/material.dart';
import '../models/produk_model.dart';

class DetailProdukPage extends StatelessWidget {
  final ProdukModel produk;

  const DetailProdukPage({super.key, required this.produk});

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

  @override
  Widget build(BuildContext context) {
    final imageUrl = fixImageUrl(produk.gambar);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 120,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                produk.namaProduk,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode Produk : ${produk.kodeProduk}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Harga : Rp ${produk.harga}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}