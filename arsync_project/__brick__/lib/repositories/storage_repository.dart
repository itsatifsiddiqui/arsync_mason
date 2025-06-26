import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storageRepoProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});

class StorageRepository {
  Future<String> uploadFile(
    XFile file, {
    required String folder,
    String? filename,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return file.path;
  }

  Future<List<String>> uploadFiles(
    List<XFile> files, {
    required String folder,
  }) async {
    final uploadFutures = files.map((file) {
      return uploadFile(file, folder: folder);
    });

    return await Future.wait(uploadFutures);
  }

  Future<void> removeFile(String url) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
