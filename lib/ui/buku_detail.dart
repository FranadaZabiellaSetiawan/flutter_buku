// ...existing code...
import 'package:flutter/material.dart';
import 'package:buku_kita/model/buku.dart';
import 'package:buku_kita/ui/buku_form.dart';
import 'package:buku_kita/bloc/buku_bloc.dart';

class BukuDetail extends StatefulWidget {
  final Buku buku;

  const BukuDetail({Key? key, required this.buku}) : super(key: key);

  @override
  _BukuDetailState createState() => _BukuDetailState();
}

class _BukuDetailState extends State<BukuDetail> {
  @override
  Widget build(BuildContext context) {
    final b = widget.buku;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _onDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Judul: ${b.judul ?? '-'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Penulis: ${b.penulis ?? '-'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Tahun Terbit: ${b.tahunPenerbit?.toString() ?? '-'}",
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Future<void> _onEdit() async {
    final result = await Navigator.push<Buku?>(
      context,
      MaterialPageRoute(builder: (_) => BukuForm(buku: widget.buku)),
    );
    if (result is Buku) {
      bool success = false;
      try {
        success = await BukuBloc.updateBuku(buku: result);
      } catch (_) {
        success = false;
      }
      if (!mounted) return;
      if (success) {
        // signal caller to refresh list and close detail
        Navigator.pop(context, true);
      } else {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Gagal'),
            content: const Text('Gagal menyimpan perubahan.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK')),
            ],
          ),
        );
      }
    }
  }

  Future<void> _onDelete() async {
    final id = widget.buku.id;
    if (id == null) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Kesalahan'),
          content: const Text('ID buku tidak tersedia.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin mau hapus buku ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (confirm != true) return;

    bool success = false;
    try {
      success = await BukuBloc.deleteBuku(id: id);
    } catch (_) {
      success = false;
    }
    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true); // signal caller to refresh
    } else {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Gagal'),
          content: const Text('Gagal menghapus data, coba lagi.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK')),
          ],
        ),
      );
    }
  }
}
// ...existing code...
