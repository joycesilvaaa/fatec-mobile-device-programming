import 'dart:io';
import 'package:flutter/material.dart';
import '../repositories/ebook_repository.dart';

class EbookReaderScreen extends StatefulWidget {
  final File file;
  final String fileName;
  final int initialPage;
  final EbookRepository repo;

  const EbookReaderScreen({
    super.key,
    required this.file,
    required this.fileName,
    required this.initialPage,
    required this.repo,
  });

  @override
  State<EbookReaderScreen> createState() => _EbookReaderScreenState();
}

class _EbookReaderScreenState extends State<EbookReaderScreen> {
  late PageController _pageController;
  List<String> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await widget.file.readAsString();
    setState(() {
      _pages = content.split('\n\n'); // cada página separada por duas quebras de linha
    });
  }

  @override
  void dispose() {
    final currentPage = _pageController.page?.toInt() ?? 0;
    widget.repo.saveProgress(widget.fileName, currentPage);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_pages[index], style: const TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}