import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/api.dart';
import '../models/produk_model.dart';

class EditProduk extends StatefulWidget {
  final ProdukModel produk;

  const EditProduk({super.key, required this.produk});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  late TextEditingController kodeProdukController;
  late TextEditingController namaProdukController;
  late TextEditingController hargaController;
  late TextEditingController gambarController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    kodeProdukController =
        TextEditingController(text: widget.produk.kodeProduk);
    namaProdukController =
        TextEditingController(text: widget.produk.namaProduk);
    hargaController =
        TextEditingController(text: widget.produk.harga.toString());
  gambarController =
    TextEditingController(text: widget.produk.gambar);
  }

  Future<void> updateProduk() async {
    if (kodeProdukController.text.isEmpty ||
        namaProdukController.text.isEmpty ||
        hargaController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Semua field wajib diisi");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse(BaseUrl.edit),
            body: {
              "id": widget.produk.id.toString(),
              "kode_produk": kodeProdukController.text,
              "nama_produk": namaProdukController.text,
              "harga": hargaController.text,
              "gambar": gambarController.text,
            },
          )
          .timeout(const Duration(seconds: 10));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = json.decode(response.body);

          if (data['status'] == true) {
            Fluttertoast.showToast(
              msg: "Produk berhasil diperbarui",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pop(context, true);
          } else {
            Fluttertoast.showToast(
              msg: data['message'] ?? "Gagal update produk",
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Response kosong dari server",
            backgroundColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server error (${response.statusCode})",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("ERROR UPDATE: $e");
      Fluttertoast.showToast(
        msg: "Tidak bisa terhubung ke server",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
        if (gambarController.text.isNotEmpty)
         Center(
          child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
          gambarController.text,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
         return const SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 200,
            height: 200,
            child: Icon(
              Icons.broken_image,
              size: 100,
              color: Colors.grey,
            ),
          );
        },
      ),
    ),
  ),

              const SizedBox(height: 12),

              TextField(
                controller: gambarController,
                decoration:
                    const InputDecoration(labelText: "URL Gambar"),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: kodeProdukController,
                decoration:
                    const InputDecoration(labelText: "Kode Produk"),
              ),

              TextField(
                controller: namaProdukController,
                decoration:
                    const InputDecoration(labelText: "Nama Produk"),
              ),

              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Harga"),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateProduk,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text("SIMPAN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}