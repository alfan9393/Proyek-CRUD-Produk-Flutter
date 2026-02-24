import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/api.dart';

class CreateProduk extends StatefulWidget {
  const CreateProduk({super.key});

  @override
  State<CreateProduk> createState() => _CreateProdukState();
}

class _CreateProdukState extends State<CreateProduk> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  bool isLoading = false;

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

  Future<void> createProduk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.tambah),
        body: {
          'kode_produk': _kodeController.text,
          'nama_produk': _namaController.text,
          'harga': _hargaController.text,
          'gambar': fixImageUrl(_gambarController.text),
        },
      );

      final result = json.decode(response.body);

      if (result['status'] == true) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _kodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gambarController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (Google / Drive / dll)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : createProduk,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}