import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderDetailScreen({Key? key, required this.provider})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.read<ProviderService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.providerName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navegar a formulario de edición
              Navigator.pushNamed(
                context,
                '/provider_form',
                arguments: provider,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text('Eliminar proveedor'),
                      content: Text(
                        '¿Seguro quieres eliminar a ${provider.providerName}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await service.deleteProvider(provider.providerId);
                Navigator.pop(context, true); // regreso al listado
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${provider.providerId}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Nombre: ${provider.providerName} ${provider.providerLastName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Correo: ${provider.providerMail}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Estado: ${provider.providerState}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
