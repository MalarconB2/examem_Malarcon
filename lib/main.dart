import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/provider_service.dart';
import 'services/product_service.dart';
import 'services/category_service.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/providers_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/products_screen.dart';
import 'screens/provider_form_screen.dart';
import 'screens/category_form_screen.dart';
import 'screens/product_form_screen.dart';

import 'models/product_model.dart';
import 'models/provider_model.dart';
import 'models/category_model.dart';

import 'theme/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => ProviderService()),
        Provider(create: (_) => CategoryService()),
        Provider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examen CMO',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.shade900,
          onPrimary: AppColors.shade100,
          secondary: AppColors.shade700,
          onSecondary: Colors.white,
          background: AppColors.shade100,
          onBackground: Colors.black87,
          surface: AppColors.shade100,
          onSurface: Colors.black,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.shade900,
          foregroundColor: AppColors.shade100,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.shade700,
          foregroundColor: AppColors.shade100,
        ),
        cardTheme: CardTheme(
          color: AppColors.shade500,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/providers': (_) => const ProvidersScreen(),
        '/categories': (_) => const CategoriesScreen(),
        '/products': (_) => const ProductsScreen(),

        // Nueva ruta para el formulario de crear/editar
        '/provider_form': (context) {
          final arg = ModalRoute.of(context)!.settings.arguments;
          return ProviderFormScreen(provider: arg as ProviderModel?);
        },

        '/category_form': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments;
          final category = args as CategoryModel?;
          return CategoryFormScreen(category: category);
        },

        '/product_form': (ctx) {
          final arg = ModalRoute.of(ctx)!.settings.arguments;
          return ProductFormScreen(product: arg as ProductModel?);
        },
      },
    );
  }
}
