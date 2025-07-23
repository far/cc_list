import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'COINCAP_KEY', obfuscate: true)
  static final String coincapApiKey = _Env.coincapApiKey;
}
