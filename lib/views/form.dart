import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController kodeProdukController;
  final TextEditingController namaProdukController;
  final TextEditingController hargaController;

  const AppForm({
    super.key,
    required this.formKey,
    required this.kodeProdukController,
    required this.namaProdukController,
    required this.hargaController,
  });

  @override
  State<AppForm> createState() => AppFormState();
}

class AppFormState extends State<AppForm> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          txtKodeProduk(),
          const SizedBox(height: 12),
          txtNamaProduk(),
          const SizedBox(height: 12),
          txtHarga(),
        ],
      ),
    );
  }

  Widget txtKodeProduk() {
    return TextFormField(
      controller: widget.kodeProdukController,
      decoration: _decoration("Kode Produk", Icons.qr_code),
      validator: (value) =>
          value == null || value.isEmpty ? "Masukkan Kode Produk" : null,
    );
  }

  Widget txtNamaProduk() {
    return TextFormField(
      controller: widget.namaProdukController,
      decoration: _decoration("Nama Produk", Icons.shopping_bag),
      validator: (value) =>
          value == null || value.isEmpty ? "Masukkan Nama Produk" : null,
    );
  }

  Widget txtHarga() {
    return TextFormField(
      controller: widget.hargaController,
      keyboardType: TextInputType.number,
      decoration: _decoration("Harga", Icons.attach_money),
      validator: (value) =>
          value == null || value.isEmpty ? "Masukkan Harga" : null,
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
