import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// En Chrome, SQLite corre como WebAssembly y guarda los datos en el navegador.
/// Requiere ejecutar una vez: dart run sqflite_common_ffi_web:setup
void configurarFabricaDb() {
  databaseFactory = databaseFactoryFfiWeb;
}
