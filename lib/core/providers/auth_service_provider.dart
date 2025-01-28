import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/providers/api_client_provider.dart';
import 'package:shopinfinity/core/providers/storage_service_provider.dart';
import 'package:shopinfinity/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);

  return AuthService(
    apiClient: apiClient,
    dio: apiClient.dio,
    storageService: storageService,
  );
});
