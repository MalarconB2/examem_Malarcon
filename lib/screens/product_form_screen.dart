// lib/screens/product_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;
  const ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _imageCtrl;
  String _state = 'Activo';
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product?.productName ?? '');
    _priceCtrl = TextEditingController(
      text: widget.product?.productPrice.toString() ?? '',
    );
    _imageCtrl = TextEditingController(
      text: widget.product?.productImage ?? '',
    );
    _state = widget.product?.productState ?? 'Activo';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final svc = context.read<ProductService>();
    try {
      final name = _nameCtrl.text.trim();
      final price = double.parse(_priceCtrl.text.trim());
      final img = _imageCtrl.text.trim();

      if (widget.product == null) {
        // crear
        await svc.addProduct(
          ProductModel(
            productId: 0,
            productName: name,
            productPrice: price,
            productImage: img,
            productState: _state,
          ),
        );
      } else {
        // editar
        await svc.editProduct(
          ProductModel(
            productId: widget.product!.productId,
            productName: name,
            productPrice: price,
            productImage: img,
            productState: _state,
          ),
        );
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
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Producto' : 'Nuevo Producto'),
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
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        (v != null && double.tryParse(v) != null)
                            ? null
                            : 'Número inválido',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: 'URL de imagen'),
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
