import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// sqflite solo trae SQLite para Android, iOS y macOS.
/// En Windows y Linux hay que activar la versión FFI (la misma de las pruebas).
void configurarFabricaDb() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
