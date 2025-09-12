import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../repositories/ebook_repository.dart';
import 'ebook_reader_screen.dart';

class EbookListScreen extends StatefulWidget {
  const EbookListScreen({super.key});

  @override
  State<EbookListScreen> createState() => _EbookListScreenState();
}

class _EbookListScreenState extends State<EbookListScreen> {
  final EbookRepository _repo = EbookRepository();
  List<FileSystemEntity> _ebooks = [];

  @override
  void initState() {
    super.initState();
    _loadEbooks();
  }

  Future<void> _loadEbooks() async {
    final ebooks = await _repo.listEbooks();
    setState(() {
      _ebooks = ebooks.whereType<File>().toList();
    });
  }

  Future<void> _uploadEbook() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      await _repo.saveEbook(file);
      _loadEbooks();
    }
  }

  Future<void> _deleteEbook(String fileName) async {
    await _repo.deleteEbook(fileName);
    _loadEbooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus E-books')),
      body: ListView.builder(
        itemCount: _ebooks.length,
        itemBuilder: (context, index) {
          final file = _ebooks[index] as File;
          final fileName = file.uri.pathSegments.last;
          return ListTile(
            title: Text(fileName),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEbook(fileName),
            ),
            onTap: () async {
              final progress = await _repo.loadProgress(fileName);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EbookReaderScreen(file: file, fileName: fileName, initialPage: progress, repo: _repo),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadEbook,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}