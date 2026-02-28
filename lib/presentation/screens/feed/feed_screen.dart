import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/review_provider.dart';
import '../../widgets/review_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(feedReviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('피드')),
      body: reviews.isEmpty
        ? const Center(child: Text('팔로우한 사람이 없어요'))
        : ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            itemCount: reviews.length,
            itemBuilder: (_, i) => ReviewCard(review: reviews[i], showBookInfo: true),
          ),
    );
  }
}
