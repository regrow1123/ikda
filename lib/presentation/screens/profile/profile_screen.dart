import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../providers/profile_provider.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/review_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final myReviews = MockDataService.reviews.where((r) => r.userId == 'me').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundImage: user.avatarUrl != null
                ? CachedNetworkImageProvider(user.avatarUrl!)
                : null,
              child: user.avatarUrl == null ? const Icon(Icons.person, size: 44) : null,
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(user.displayName ?? user.username, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
          Center(child: Text('@${user.username}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          if (user.bio != null) ...[
            const SizedBox(height: 8),
            Center(child: Text(user.bio!, style: theme.textTheme.bodyMedium)),
          ],
          const SizedBox(height: 20),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat(context, '${user.booksCount}', '읽은 책'),
              _stat(context, '${user.reviewsCount}', '리뷰'),
              _stat(context, '${user.followersCount}', '팔로워'),
              _stat(context, '${user.followingCount}', '팔로잉'),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),

          // My reviews
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('내 리뷰', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          if (myReviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('아직 리뷰가 없어요')),
            )
          else
            ...myReviews.map((r) => ReviewCard(review: r, showBookInfo: true)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(count, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
