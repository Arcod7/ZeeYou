import 'dart:io';
import 'package:path/path.dart' as p;

// import 'package:path_provider/path_provider.dart';

class KeysPath {
  static const String mapsApiKey = 'keys/maps_api_key';
  static const String passwordMalek = 'keys/password_malek';
  static const String passwordTest = 'keys/password_test';
}

Future<String> readFile (String path) async {
  // String text = "NO_KEY";
  // try {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   print(directory.path);
  //   final File file = File('${directory.path}/$path');
  //   text = await file.readAsString();
  // } catch (e) {
  //   print("Couldn't read file");
  // }
  // return text;
  print(Directory.current.path);
  final folderPath = p.join('./', '');
  print(Platform.environment['PWD']);
  // Directory(Platform.environment['PWD']).list().listen((event) {
  //   print(event.path);
  // });
  // File(folderPath).().then((value) => print(value));
  // todo: remove path_provider

  return File(folderPath).readAsString();
}
