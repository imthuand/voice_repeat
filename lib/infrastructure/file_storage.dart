import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStorage {
  static const _baseFolder = 'voice_repeat';
  static const _activeFolder = 'active';
  static const _archiveFolder = 'archive';

  Future<Directory> _ensureDir(String name) async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, _baseFolder, name));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> newActivePath(String itemId) async {
    final dir = await _ensureDir(_activeFolder);
    return p.join(dir.path, '$itemId.m4a');
  }

  Future<String> archivePath(String itemId) async {
    final dir = await _ensureDir(_archiveFolder);
    return p.join(dir.path, '$itemId.m4a');
  }

  Future<int> fileSize(String path) async {
    final f = File(path);
    if (!await f.exists()) return 0;
    return f.length();
  }

  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  Future<void> move(String from, String to) async {
    final f = File(from);
    if (!await f.exists()) return;

    final toFile = File(to);
    final toDir = toFile.parent;
    if (!await toDir.exists()) {
      await toDir.create(recursive: true);
    }

    try {
      await f.rename(to);
    } catch (_) {
      await f.copy(to);
      try {
        await f.delete();
      } catch (_) {}
    }
  }

  Future<void> deleteIfExists(String path) async {
    final f = File(path);
    if (await f.exists()) {
      await f.delete();
    }
  }

  Future<List<FileSystemEntity>> listArchivedFiles() async {
    final dir = await _ensureDir(_archiveFolder);
    return dir.list(followLinks: false).toList();
  }

  Future<List<FileSystemEntity>> listActiveFiles() async {
    final dir = await _ensureDir(_activeFolder);
    return dir.list(followLinks: false).toList();
  }
}