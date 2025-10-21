class Buku {
  int? id;
  String? judul;
  String? penulis;
  int? tahunTerbit;

  Buku({
    this.id,
    this.judul,
    this.penulis,
    this.tahunTerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      judul: json['judul'],
      penulis: json['penulis'],
      tahunTerbit: json['tahunTerbit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'penulis': penulis,
      'tahunTerbit': tahunTerbit,
    };
  }
}
