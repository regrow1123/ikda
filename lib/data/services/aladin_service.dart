import 'package:dio/dio.dart';
import '../models/book.dart';
import '../../core/constants/supabase_constants.dart';

class AladinService {
  // Supabase Edge Function proxy (CORS-safe)
  static final _proxyBase = '${SupabaseConstants.url}/functions/v1/aladin-proxy';
  static final _dio = Dio();

  /// 책 검색
  static Future<List<Book>> search(String query, {int page = 1}) async {
    final res = await _dio.get(_proxyBase, queryParameters: {
      'endpoint': 'ItemSearch.aspx',
      'Query': query,
      'QueryType': 'Keyword',
      'MaxResults': 20,
      'Start': page,
      'SearchTarget': 'Book',
      'Cover': 'Big',
    });
    return _parseItems(res.data);
  }

  /// 베스트셀러
  static Future<List<Book>> bestsellers({String categoryId = '0'}) async {
    final res = await _dio.get(_proxyBase, queryParameters: {
      'endpoint': 'ItemList.aspx',
      'QueryType': 'Bestseller',
      'MaxResults': 20,
      'Start': 1,
      'SearchTarget': 'Book',
      'CategoryId': categoryId,
      'Cover': 'Big',
    });
    return _parseItems(res.data);
  }

  /// 신간
  static Future<List<Book>> newBooks({String categoryId = '0'}) async {
    final res = await _dio.get(_proxyBase, queryParameters: {
      'endpoint': 'ItemList.aspx',
      'QueryType': 'ItemNewAll',
      'MaxResults': 20,
      'Start': 1,
      'SearchTarget': 'Book',
      'CategoryId': categoryId,
      'Cover': 'Big',
    });
    return _parseItems(res.data);
  }

  /// 책 상세
  static Future<Book?> getDetail(String isbn13) async {
    final res = await _dio.get(_proxyBase, queryParameters: {
      'endpoint': 'ItemLookUp.aspx',
      'ItemId': isbn13,
      'ItemIdType': 'ISBN13',
      'OptResult': 'authors,fulldescription,Toc',
      'Cover': 'Big',
    });
    final items = _parseItems(res.data);
    return items.isNotEmpty ? items.first : null;
  }

  static List<Book> _parseItems(dynamic data) {
    if (data == null) return [];

    // Dio가 JSON을 자동 파싱하는 경우
    final Map<String, dynamic> json;
    if (data is Map<String, dynamic>) {
      json = data;
    } else {
      return [];
    }

    final items = json['item'] as List<dynamic>? ?? [];
    return items.map((item) {
      final i = item as Map<String, dynamic>;
      return Book(
        id: i['itemId'] as int? ?? 0,
        title: (i['title'] as String? ?? '').split(' - ').first.trim(),
        author: (i['author'] as String? ?? '').replaceAll(RegExp(r'\s*\(지은이\).*'), ''),
        publisher: i['publisher'] as String? ?? '',
        coverUrl: (i['cover'] as String? ?? '').replaceAll('coversum', 'cover500'),
        description: i['description'] as String? ?? i['fullDescription'] as String? ?? '',
        category: i['categoryName'] as String? ?? '',
        isbn13: i['isbn13'] as String? ?? '',
        pubDate: DateTime.tryParse(i['pubDate'] as String? ?? ''),
        avgRating: (i['customerReviewRank'] as num?)?.toDouble().let((v) => v / 2),
        ratingCount: null,
      );
    }).toList();
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) fn) => fn(this);
}
