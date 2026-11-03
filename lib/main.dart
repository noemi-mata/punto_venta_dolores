import 'package:flutter/material.dart';
import 'datos/base_datos.dart';
import 'datos/fabrica_db.dart';
import 'datos/repositorio_productos.dart';
import 'datos/repositorio_ventas.dart';
import 'presentacion/caja_viewmodel.dart';
import 'presentacion/pantalla_caja.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Elige el "motor" de SQLite según dónde corre la app
  // (Android/iOS: nativo · Windows/Linux: FFI · Chrome: WebAssembly).
  configurarFabricaDb();
  // Dibujamos la app DE INMEDIATO. Antes se esperaba a la base de datos
  // antes de runApp: si fallaba, la pantalla se quedaba en blanco.
  runApp(const AppPuntoVenta());
}

class AppPuntoVenta extends StatefulWidget {
  const AppPuntoVenta({super.key});

  @override
  State<AppPuntoVenta> createState() => _AppPuntoVentaState();
}

class _AppPuntoVentaState extends State<AppPuntoVenta> {
  late final Future<CajaViewModel> _arranque = _iniciar();

  /// Composition root: aquí se crean y conectan todos los objetos.
  Future<CajaViewModel> _iniciar() async {
    final db = await BaseDatos.abrir();
    final productos = RepositorioProductos(db);
    await productos.sembrarEjemplos();
    return CajaViewModel(productos, RepositorioVentas(db));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta Dolores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: FutureBuilder<CajaViewModel>(
        future: _arranque,
        builder: (context, snap) {
          if (snap.hasError) {
            // Si algo falla, lo mostramos en pantalla en lugar de quedar en blanco.
            return Scaffold(
              appBar: AppBar(title: const Text('Error al iniciar')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text('No se pudo abrir la base de datos:\n\n${snap.error}'),
                ),
              ),
            );
          }
          if (!snap.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return PantallaCaja(vm: snap.data!);
        },
      ),
    );
  }
}
