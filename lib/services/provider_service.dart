import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider_model.dart';

class ProviderService {
  final String _user = 'test';
  final String _pass = 'test2023';
  final String _baseUrl = 'http://143.198.118.203:8100';

  Future<List<ProviderModel>> fetchProviders() async {
    final uri = Uri.parse('$_baseUrl/ejemplos/provider_list_rest/');
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $creds',
    };

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Error al obtener proveedores: ${resp.statusCode}');
    }

    final decoded = jsonDecode(resp.body);
    if (decoded is Map<String, dynamic> &&
        decoded['Proveedores Listado'] is List) {
      final listData = decoded['Proveedores Listado'] as List;
      return listData
          .map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Formato de respuesta inesperado: no contiene "Proveedores Listado"',
      );
    }
  }

  // 2) Método para eliminar un proveedor
  Future<void> deleteProvider(int providerId) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/provider_del_rest/');
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $creds',
    };
    final body = jsonEncode({'provider_id': providerId});
    final resp = await http.post(uri, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Error al eliminar proveedor: ${resp.statusCode}');
    }
  }

  // 3) Método para editar un proveedor
  Future<ProviderModel> editProvider(ProviderModel p) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/provider_edit_rest/');
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $creds',
    };
    final body = jsonEncode({
      'provider_id': p.providerId,
      'provider_name': p.providerName,
      'provider_last_name': p.providerLastName,
      'provider_mail': p.providerMail,
      'provider_state': p.providerState,
    });
    final resp = await http.post(uri, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Error al editar proveedor: ${resp.statusCode}');
    }
    return ProviderModel.fromJson(jsonDecode(resp.body));
  }

  /// Crea un nuevo proveedor
  Future<ProviderModel> addProvider(ProviderModel p) async {
    final uri = Uri.parse('$_baseUrl/ejemplos/provider_add_rest/');
    final creds = base64Encode(utf8.encode('$_user:$_pass'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $creds',
    };
    final body = jsonEncode({
      'provider_name': p.providerName,
      'provider_last_name': p.providerLastName,
      'provider_mail': p.providerMail,
      'provider_state': p.providerState,
    });
    final resp = await http.post(uri, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Error al crear proveedor: ${resp.statusCode}');
    }
    return ProviderModel.fromJson(jsonDecode(resp.body));
  }
}
