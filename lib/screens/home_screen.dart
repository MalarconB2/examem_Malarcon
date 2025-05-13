import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MenuCard(
              label: 'Proveedores',
              icon: Icons.group,
              routeName: '/providers',
            ),
            SizedBox(height: 16),
            _MenuCard(
              label: 'Categorías',
              icon: Icons.category,
              routeName: '/categories',
            ),
            SizedBox(height: 16),
            _MenuCard(
              label: 'Productos',
              icon: Icons.inventory,
              routeName: '/products',
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String routeName;

  const _MenuCard({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              SizedBox(width: 16),
              Text(label, style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
