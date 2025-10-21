class Buku {
  int? id;
  String? judul;
  String? penulis;
  int? tahunPenerbit;

  Buku({
    this.id,
    this.judul,
    this.penulis,
    this.tahunPenerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      judul: json['judul'],
      penulis: json['penulis'],
      tahunPenerbit: json['tahun_penerbit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'penulis': penulis,
      'tahun_penerbit': tahunPenerbit,
    };
  }
}
