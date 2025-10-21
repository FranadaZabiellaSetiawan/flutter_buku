// ...existing code...
import 'package:flutter/material.dart';
import 'package:buku_kita/ui/buku_form.dart';
import 'package:buku_kita/model/buku.dart';
import 'package:buku_kita/bloc/buku_bloc.dart';
import 'package:buku_kita/ui/login_page.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  List<Buku> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    try {
      final list = await BukuBloc.getBukuList();
      setState(() => _items = list);
    } catch (_) {
      setState(() => _items = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final result = await Navigator.push<Buku?>(
      context,
      MaterialPageRoute(builder: (_) => const BukuForm()),
    );
    if (result is Buku) {
      try {
        await BukuBloc.addBuku(buku: result);
      } catch (_) {}
      await _load();
    }
  }

  Future<void> _edit(Buku buku) async {
    final result = await Navigator.push<Buku?>(
      context,
      MaterialPageRoute(builder: (_) => BukuForm(buku: buku)),
    );
    if (result is Buku) {
      try {
        await BukuBloc.updateBuku(buku: result);
      } catch (_) {}
      await _load();
    }
  }

  Future<void> _delete(Buku buku) async {
    if (buku.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus buku ini?'),
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

    try {
      await BukuBloc.deleteBuku(id: buku.id!);
    } catch (_) {}
    await _load();
  }

  // changed: do NOT remove token on logout — just navigate to LoginPage
  Future<void> _logout() async {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Menu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Daftar Buku'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.of(context).pop(); // close drawer
                  await _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('Belum ada buku'))
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final b = _items[index];
                    return ListTile(
                      title: Text(b.judul ?? '-'),
                      subtitle: Text(
                          '${b.penulis ?? '-'} • ${b.tahunPenerbit ?? '-'}'),
                      onTap: () => _edit(b),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(b),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
// ...existing code...
