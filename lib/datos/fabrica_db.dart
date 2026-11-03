// Escoge automáticamente el archivo correcto:
// - En Chrome (web) usa fabrica_db_web.dart
// - En Android, iOS, Windows, Linux y macOS usa fabrica_db_io.dart
export 'fabrica_db_io.dart' if (dart.library.js_interop) 'fabrica_db_web.dart';
