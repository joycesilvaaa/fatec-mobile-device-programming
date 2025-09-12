import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class EbookRepository {
  Future<Directory> getEbookDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final ebookDir = Directory('${dir.path}/ebooks');
    if (!await ebookDir.exists()) {
      await ebookDir.create(recursive: true);
    }
    return ebookDir;
  }

  Future<List<FileSystemEntity>> listEbooks() async {
    final ebookDir = await getEbookDirectory();
    return ebookDir.listSync();
  }

  Future<File> saveEbook(File sourceFile) async {
    final ebookDir = await getEbookDirectory();
    final fileName = sourceFile.uri.pathSegments.last;
    final newFile = File('${ebookDir.path}/$fileName');
    return await sourceFile.copy(newFile.path);
  }

  Future<void> deleteEbook(String fileName) async {
    final ebookDir = await getEbookDirectory();
    final file = File('${ebookDir.path}/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
    // Remove progresso salvo
    final progressFile = File('${ebookDir.path}/$fileName.progress.json');
    if (await progressFile.exists()) {
      await progressFile.delete();
    }
  }

  Future<int> loadProgress(String fileName) async {
    final ebookDir = await getEbookDirectory();
    final progressFile = File('${ebookDir.path}/$fileName.progress.json');
    if (await progressFile.exists()) {
      final content = await progressFile.readAsString();
      final data = json.decode(content);
      return data['currentPage'] ?? 0;
    }
    return 0;
  }

  Future<void> saveProgress(String fileName, int currentPage) async {
    final ebookDir = await getEbookDirectory();
    final progressFile = File('${ebookDir.path}/$fileName.progress.json');
    final data = {'currentPage': currentPage};
    await progressFile.writeAsString(json.encode(data));
  }
}