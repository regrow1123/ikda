import 'dart:convert';
import 'package:dio/dio.dart';

class GeminiService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _model = 'gemini-2.0-flash';
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  /// 성찰 질문 생성
  static Future<String> generateReflectionQuestions({
    required String quote,
    required String bookTitle,
    required String bookAuthor,
    String? userNote,
    String? mood,
  }) async {
    final prompt = '''당신은 독서 성찰을 도와주는 따뜻한 가이드입니다.

사용자가 다음 책에서 문구를 스크랩했습니다:

📖 책: "$bookTitle" - $bookAuthor
💬 문구: "$quote"
${userNote != null ? '📝 사용자 메모: "$userNote"' : ''}
${mood != null ? '🎭 감정: $mood' : ''}

이 문구에 대해 사용자가 더 깊이 생각해볼 수 있도록 성찰 질문 2-3개를 한국어로 만들어주세요.
질문은 개인적이고 따뜻하며, 자기 이해를 돕는 방향이어야 합니다.
번호를 매겨서 질문만 간결하게 작성해주세요.''';

    return _chat([{'role': 'user', 'text': prompt}]);
  }

  /// 대화 계속하기 (사용자 답변에 대한 후속 응답)
  static Future<String> continueConversation({
    required List<Map<String, dynamic>> history,
    required String userMessage,
  }) async {
    final messages = <Map<String, String>>[];

    // 시스템 컨텍스트
    messages.add({
      'role': 'user',
      'text': '당신은 독서 성찰을 도와주는 따뜻한 가이드입니다. 사용자의 답변에 공감하고, 필요하면 추가 질문을 하거나 통찰을 나눠주세요. 한국어로 답변하세요. 길지 않게 2-3문장으로.'
    });
    messages.add({'role': 'model', 'text': '네, 함께 이야기 나눠볼게요.'});

    // 기존 대화 기록
    for (final msg in history) {
      messages.add({
        'role': msg['role'] as String,
        'text': msg['text'] as String,
      });
    }

    // 새 사용자 메시지
    messages.add({'role': 'user', 'text': userMessage});

    return _chat(messages);
  }

  /// 성찰 요약 생성
  static Future<String> generateSummary({
    required String quote,
    required List<Map<String, dynamic>> conversation,
  }) async {
    final conversationText = conversation
        .map((m) => '${m['role'] == 'user' ? '사용자' : 'AI'}: ${m['text']}')
        .join('\n');

    final prompt = '''다음은 사용자가 책 문구에 대해 나눈 성찰 대화입니다.

문구: "$quote"

대화:
$conversationText

이 대화에서 얻은 핵심 통찰을 한국어로 2-3문장으로 요약해주세요. 따뜻하고 개인적인 톤으로.''';

    return _chat([{'role': 'user', 'text': prompt}]);
  }

  /// SD 이미지 생성용 프롬프트 생성
  static Future<String> generateImagePrompt({
    required String quote,
    required String? summary,
    required String? mood,
  }) async {
    final prompt = '''Generate a Stable Diffusion image prompt for this book quote illustration.

Quote: "$quote"
${summary != null ? 'Reflection summary: "$summary"' : ''}
${mood != null ? 'Mood: $mood' : ''}

Create a beautiful, artistic, watercolor-style illustration prompt in English.
The prompt should capture the emotional essence of the quote.
Output ONLY the prompt, nothing else. Keep it under 100 words.
Do not include any negative prompt.''';

    return _chat([{'role': 'user', 'text': prompt}]);
  }

  static Future<String> _chat(List<Map<String, String>> messages) async {
    final contents = <Map<String, dynamic>>[];

    for (final msg in messages) {
      contents.add({
        'role': msg['role'] == 'model' ? 'model' : 'user',
        'parts': [{'text': msg['text']}],
      });
    }

    final res = await _dio.post(
      '$_baseUrl/models/$_model:generateContent?key=$_apiKey',
      data: jsonEncode({'contents': contents}),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final data = res.data is String ? jsonDecode(res.data) : res.data;
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return '응답을 생성하지 못했어요.';

    final parts = candidates[0]['content']['parts'] as List<dynamic>;
    return parts.map((p) => p['text']).join('');
  }
}
