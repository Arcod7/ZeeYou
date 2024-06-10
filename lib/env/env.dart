import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'FIREBASE_API_KEY', obfuscate: true)
  static final String firebaseApiKey = _Env.firebaseApiKey;
  @EnviedField(varName: 'MAPS_API_KEY', obfuscate: true)
  static final String mapsApiKey = _Env.mapsApiKey;
  @EnviedField(varName: 'KPLACES_API_KEY', obfuscate: true)
  static final String kplacesApiKey = _Env.kplacesApiKey;
  @EnviedField(varName: 'PASSWORD_MALEK', obfuscate: true)
  static final String passwordMalek = _Env.passwordMalek;
  @EnviedField(varName: 'PASSWORD_TEST', obfuscate: true)
  static final String passwordTest = _Env.passwordTest;
}
