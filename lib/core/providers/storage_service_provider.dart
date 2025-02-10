import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/services/storage_service.dart';
import 'dart:developer' as dev;

final storageServiceProvider = Provider<StorageService>((ref) {
  // dev.log('Creating storage service...', name: 'StorageServiceProvider');
  final storageService = StorageService();

  // Initialize the storage service
  Future<void> initialize() async {
    try {
      // dev.log('Initializing storage service...',
      //     name: 'StorageServiceProvider');
      await storageService.init();
      // dev.log('Storage service initialized successfully',
      //     name: 'StorageServiceProvider');
    } catch (e, stack) {
      dev.log('Error initializing storage service: $e\n$stack',
          name: 'StorageServiceProvider', error: e);
    }
  }

  // Call initialize immediately
  initialize();

  return storageService;
});
