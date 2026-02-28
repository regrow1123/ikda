import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/my_bookshelf/bookshelf_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/book_detail/book_detail_screen.dart';
import '../presentation/screens/recommendation/recommendation_screen.dart';
import '../presentation/screens/highlight/highlight_list_screen.dart';
import '../presentation/screens/highlight/highlight_add_screen.dart';
import '../presentation/screens/highlight/highlight_detail_screen.dart';
import 'shell_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/bookshelf',
          builder: (context, state) => const BookshelfScreen(),
        ),
        GoRoute(
          path: '/highlights',
          builder: (context, state) => const HighlightListScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/highlight/add',
      builder: (context, state) => const HighlightAddScreen(),
    ),
    GoRoute(
      path: '/highlight/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return HighlightDetailScreen(highlightId: id);
      },
    ),
    GoRoute(
      path: '/recommendations',
      builder: (context, state) => const RecommendationScreen(),
    ),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BookDetailScreen(bookId: id);
      },
    ),
  ],
);
