import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/services/storage_service.dart';
import 'package:shopinfinity/core/network/api_client.dart';
import 'package:shopinfinity/core/services/product_service.dart';
import 'package:shopinfinity/core/services/auth_service.dart';
import 'package:shopinfinity/core/services/category_service.dart';
import 'dart:developer' as dev;

// Global provider for storage service
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Storage service must be initialized in main');
});

// Global provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  dev.log('Creating API client with storage service', name: 'Providers');
  return ApiClient(storageService: storageService);
});

// Global provider for product service
final productServiceProvider = Provider<ProductService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  dev.log('Creating product service with API client and storage service', name: 'Providers');
  return ProductService(apiClient: apiClient, storageService: storageService);
});

// Global provider for auth service
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  dev.log('Creating auth service with API client', name: 'Providers');
  return AuthService(apiClient: apiClient);
});

// Global provider for category service
final categoryServiceProvider = Provider<CategoryService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return CategoryService(
    apiClient: apiClient,
    storageService: storageService,
  );
});
