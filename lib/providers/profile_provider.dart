import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/profile.dart';
import '../data/services/mock_data_service.dart';

final currentUserProvider = Provider<Profile>((ref) => MockDataService.currentUser);
