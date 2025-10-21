import 'dart:convert';
import 'package:buku_kita/helpers/api.dart';
import 'package:buku_kita/helpers/api_url.dart';
import '../model/buku.dart';

class BukuBloc {
  // Use ApiUrl and Api helper so headers and errors are handled consistently.
  static Future<List<Buku>> getBukuList() async {
    final response = await Api().get(ApiUrl.listBuku);
    final Iterable data = json.decode(response.body);
    return data.map((e) => Buku.fromJson(e)).toList();
  }

  static Future<bool> addBuku({required Buku buku}) async {
    // Convert values to String to send as form data via Api().post
    final Map<String, String> body = {};
    buku.toJson().forEach((k, v) {
      if (v != null) body[k] = v.toString();
    });
    final response = await Api().post(ApiUrl.createBuku, body);
    return response.statusCode == 201;
  }

  static Future<bool> updateBuku({required Buku buku}) async {
    final Map<String, String> body = {};
    buku.toJson().forEach((k, v) {
      if (v != null) body[k] = v.toString();
    });
    final url = ApiUrl.updateBuku(buku.id ?? 0);
    final response = await Api().post(url,
        body); // use POST if your backend expects it, or change to Api().put if available
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> deleteBuku({required int id}) async {
    final url = ApiUrl.deleteBuku(id);
    final response = await Api().delete(url);
    return response.statusCode == 200;
  }
}
