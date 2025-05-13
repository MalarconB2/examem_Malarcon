import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryFormScreen extends StatefulWidget {
  final CategoryModel? category;
  const CategoryFormScreen({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  late final TextEditingController _nameCtrl;
  String _state = 'Activo';
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: widget.category?.categoryName ?? '',
    );
    _state = widget.category?.categoryState ?? 'Activo';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final service = context.read<CategoryService>();
    try {
      if (widget.category == null) {
        // Crear
        await service.addCategory(_nameCtrl.text.trim());
      } else {
        // Editar
        final edited = CategoryModel(
          categoryId: widget.category!.categoryId,
          categoryName: _nameCtrl.text.trim(),
          categoryState: _state,
        );
        await service.editCategory(edited);
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
    final isEdit = widget.category != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Categoría' : 'Nueva Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _state,
                items: const [
                  DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                  DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                ],
                onChanged: (v) => setState(() => _state = v!),
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEdit ? 'Guardar' : 'Crear'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
