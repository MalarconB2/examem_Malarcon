import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  final String _user = 'test';
  final String _pass = 'test2023';
  final String _baseUrl = 'http://143.198.118.203:8100';

  String _authHeader() {
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    return 'Basic $creds';
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/ejemplos/category_list_rest/');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader(),
      },
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al obtener categorías: ${resp.statusCode}');
    }
    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    final listData =
        decoded['Categories Listado'] as List? ?? decoded.values.first as List;
    return listData.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> addCategory(String name) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/category_add_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader(),
      },
      body: jsonEncode({'category_name': name}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al crear categoría: ${resp.statusCode}');
    }
    return CategoryModel.fromJson(jsonDecode(resp.body));
  }

  Future<CategoryModel> editCategory(CategoryModel c) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/category_edit_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader(),
      },
      body: jsonEncode({
        'category_id': c.categoryId,
        'category_name': c.categoryName,
        'category_state': c.categoryState,
      }),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al editar categoría: ${resp.statusCode}');
    }
    return CategoryModel.fromJson(jsonDecode(resp.body));
  }

  Future<void> deleteCategory(int categoryId) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/category_del_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader(),
      },
      body: jsonEncode({'category_id': categoryId}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al eliminar categoría: ${resp.statusCode}');
    }
  }
}
