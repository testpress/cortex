import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/app_config.dart';
import '../models/client_config.dart';

part 'client_config_provider.g.dart';

@Riverpod(keepAlive: true)
ClientConfig clientConfig(ClientConfigRef ref) {
  final baseUrl = AppConfig.apiBaseUrl;
  
  // Logic to determine client config based on subdomain.
  // In a real app, this might be fetched from a /config/ API.
  if (baseUrl.contains('brilliant')) {
    return ClientConfig.brilliant;
  }
  
  return ClientConfig.defaultGeneral;
}
