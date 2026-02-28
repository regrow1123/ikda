import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final int bookId;

  const ReviewScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리뷰 작성')),
      body: Center(child: Text('Write review for book $bookId')),
    );
  }
}
