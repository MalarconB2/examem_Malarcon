import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String _user = 'test';
  final String _pass = 'test2023';
  final String _baseUrl = 'http://143.198.118.203:8100';

  String get _authHeader {
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    return 'Basic $creds';
  }

  Future<List<ProductModel>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/ejemplos/product_list_rest/');
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $creds',
    };

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Error al obtener productos: ${resp.statusCode}');
    }

    final decoded = jsonDecode(resp.body);
    late List<dynamic> listData;

    if (decoded is List) {
      listData = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['Products Listado'] is List) {
        listData = decoded['Products Listado'];
      } else if (decoded['Productos Listado'] is List) {
        listData = decoded['Productos Listado'];
      } else if (decoded.containsKey('data') && decoded['data'] is List) {
        listData = decoded['data'];
      } else {
        final candidate = decoded.values.firstWhere(
          (v) => v is List,
          orElse:
              () =>
                  throw Exception(
                    'Formato inesperado: no contiene lista de productos',
                  ),
        );
        listData = candidate as List;
      }
    } else {
      throw Exception('JSON de respuesta inválido');
    }

    return listData
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteProduct(int id) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/product_del_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader,
      },
      body: jsonEncode({'product_id': id}),
    );
    if (resp.statusCode != 200)
      throw Exception('Error al eliminar: ${resp.statusCode}');
  }

  Future<ProductModel> editProduct(ProductModel p) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/product_edit_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader,
      },
      body: jsonEncode({
        'product_id': p.productId,
        'product_name': p.productName,
        'product_price': p.productPrice,
        'product_image': p.productImage,
        'product_state': p.productState,
      }),
    );
    if (resp.statusCode != 200)
      throw Exception('Error al editar: ${resp.statusCode}');
    return ProductModel.fromJson(jsonDecode(resp.body));
  }

  Future<ProductModel> addProduct(ProductModel p) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/product_add_rest/');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _authHeader,
      },
      body: jsonEncode({
        'product_name': p.productName,
        'product_price': p.productPrice,
        'product_image': p.productImage,
        'product_state': p.productState,
      }),
    );
    if (resp.statusCode != 200)
      throw Exception('Error al crear: ${resp.statusCode}');
    return ProductModel.fromJson(jsonDecode(resp.body));
  }
}
