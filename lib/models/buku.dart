class Buku {
  final int id;
  final int tahunPenerbit;
  final String judul;
  final String penulis;

  const Buku({
    required this.id,
    required this.tahunPenerbit,
    required this.judul,
    required this.penulis,
  });

  factory Buku.fromJson(Map<String, dynamic> json) => Buku(
    id: json['id'],
    tahunPenerbit: json['tahun_penerbit'] as int,
    judul: json['judul'] as String,
    penulis: json['penulis'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'tahun_penerbit': tahunPenerbit,
    'judul': judul,
    'penulis': penulis,
  };
}
