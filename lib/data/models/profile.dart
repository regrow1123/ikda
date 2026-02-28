class Profile {
  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final int booksCount;
  final int reviewsCount;
  final int followersCount;
  final int followingCount;

  const Profile({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.booksCount = 0,
    this.reviewsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });
}
