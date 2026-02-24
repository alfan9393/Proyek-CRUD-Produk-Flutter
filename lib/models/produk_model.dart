class ProdukModel {
  final int id;
  final String kodeProduk;
  final String namaProduk;
  final int harga;
  final String gambar; 

  ProdukModel({
    required this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.harga,
    required this.gambar,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: int.parse(json['id'].toString()),
      kodeProduk: json['kode_produk'],
      namaProduk: json['nama_produk'],
      harga: int.parse(json['harga'].toString()),
      gambar: json['gambar'] ?? '', 
    );
  }

  static List<ProdukModel> fromJsonList(List list) {
    return list.map((e) => ProdukModel.fromJson(e)).toList();
  }
}
