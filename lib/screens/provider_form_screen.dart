import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';

class ProviderFormScreen extends StatefulWidget {
  final ProviderModel? provider;
  const ProviderFormScreen({Key? key, this.provider}) : super(key: key);

  @override
  State<ProviderFormScreen> createState() => _ProviderFormScreenState();
}

class _ProviderFormScreenState extends State<ProviderFormScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _mailCtrl;
  String _state = 'Activo';
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(
      text: widget.provider?.providerName ?? '',
    );
    _lastNameCtrl = TextEditingController(
      text: widget.provider?.providerLastName ?? '',
    );
    _mailCtrl = TextEditingController(
      text: widget.provider?.providerMail ?? '',
    );
    _state = widget.provider?.providerState ?? 'Activo';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _mailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final service = context.read<ProviderService>();
    try {
      if (widget.provider == null) {
        // Crear
        final newProv = ProviderModel(
          providerId: 0,
          providerName: _nameCtrl.text.trim(),
          providerLastName: _lastNameCtrl.text.trim(),
          providerMail: _mailCtrl.text.trim(),
          providerState: _state,
        );
        await service.addProvider(newProv);
      } else {
        // Editar
        final edited = ProviderModel(
          providerId: widget.provider!.providerId,
          providerName: _nameCtrl.text.trim(),
          providerLastName: _lastNameCtrl.text.trim(),
          providerMail: _mailCtrl.text.trim(),
          providerState: _state,
        );
        await service.editProvider(edited);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.provider != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Proveedor' : 'Nuevo Proveedor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _mailCtrl,
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (v) => v!.contains('@') ? null : 'Email inválido',
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _state,
                items:
                    ['Activo', 'Inactivo']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (v) => setState(() => _state = v!),
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              SizedBox(height: 16),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEdit ? 'Guardar Cambios' : 'Crear'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
