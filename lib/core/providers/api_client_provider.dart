import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/providers/storage_service_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiClient(storageService: storageService);
});
