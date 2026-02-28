import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('책 상세')),
      body: Center(child: Text('Book ID: $bookId')),
    );
  }
}
