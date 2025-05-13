import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';
import 'provider_detail_screen.dart';
import 'provider_form_screen.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({Key? key}) : super(key: key);

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  late Future<List<ProviderModel>> _futureProviders;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    _futureProviders = context.read<ProviderService>().fetchProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: FutureBuilder<List<ProviderModel>>(
        future: _futureProviders,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          } else if (snap.data!.isEmpty) {
            return const Center(child: Text('No hay proveedores'));
          }
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final p = list[i];
              return ListTile(
                title: Text(p.providerName),
                subtitle: Text(p.providerMail),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final didDelete = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProviderDetailScreen(provider: p),
                    ),
                  );
                  if (didDelete == true) {
                    setState(_loadProviders);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, '/provider_form');
          if (created == true) {
            setState(_loadProviders);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
