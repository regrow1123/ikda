import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_book.dart';
import '../data/services/mock_data_service.dart';

final bookshelfProvider = Provider.family<List<UserBook>, BookStatus>((ref, status) =>
  MockDataService.getUserBooks(status));
