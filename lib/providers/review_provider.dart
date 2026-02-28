import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/review.dart';
import '../data/services/mock_data_service.dart';

final bookReviewsProvider = Provider.family<List<Review>, int>((ref, bookId) =>
  MockDataService.getBookReviews(bookId));

final feedReviewsProvider = Provider<List<Review>>((ref) => MockDataService.reviews);
