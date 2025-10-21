// ...existing code...
import 'package:flutter/material.dart';
import 'package:buku_kita/model/buku.dart';

class BukuForm extends StatefulWidget {
  final Buku? buku;

  const BukuForm({Key? key, this.buku}) : super(key: key);

  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _penulisController;
  late final TextEditingController _tahunController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.buku?.judul ?? '');
    _penulisController = TextEditingController(text: widget.buku?.penulis ?? '');
    _tahunController =
        TextEditingController(text: widget.buku?.tahunTerbit?.toString() ?? '');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _tahunController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    final String judul = _judulController.text.trim();
    final String penulis = _penulisController.text.trim();
    final String tahunText = _tahunController.text.trim();
    final int? tahun = tahunText.isEmpty ? null : int.tryParse(tahunText);

    // Ensure 'tahun' variable exists and use it here.
    final Buku result = Buku(
      id: widget.buku?.id,
      judul: judul,
      penulis: penulis,
      tahunTerbit: tahun, // using local variable 'tahun'
    );

    if (!mounted) return;
    Navigator.pop(context, result);
    // don't call setState after pop
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buku != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Buku' : 'Tambah Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tahunController,
                decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return int.tryParse(v.trim()) == null ? 'Masukkan angka yang valid' : null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _onSave,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ...existing code...