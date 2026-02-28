import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/highlight.dart';
import '../../../providers/highlight_provider.dart';
import 'reflection_chat_screen.dart';

class HighlightAddScreen extends ConsumerStatefulWidget {
  final int? bookId;
  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCoverUrl;

  const HighlightAddScreen({
    super.key,
    this.bookId,
    this.bookTitle,
    this.bookAuthor,
    this.bookCoverUrl,
  });

  @override
  ConsumerState<HighlightAddScreen> createState() => _HighlightAddScreenState();
}

class _HighlightAddScreenState extends ConsumerState<HighlightAddScreen> {
  final _quoteController = TextEditingController();
  final _noteController = TextEditingController();
  final _pageController = TextEditingController();
  String? _selectedMood;

  final _moods = ['감동', '영감', '공감', '슬픔', '따뜻함', '재미', '놀라움', '위로'];
  List<Map<String, dynamic>>? _llmConversation;
  String? _llmSummary;

  @override
  void dispose() {
    _quoteController.dispose();
    _noteController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _save() {
    if (_quoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문구를 입력해주세요')),
      );
      return;
    }

    final highlight = Highlight(
      userId: 'user1', // 더미 유저
      bookId: widget.bookId ?? 0,
      quote: _quoteController.text.trim(),
      myNote: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      pageNumber: int.tryParse(_pageController.text),
      mood: _selectedMood,
      llmConversation: _llmConversation ?? [],
      llmSummary: _llmSummary,
      bookTitle: widget.bookTitle,
      bookAuthor: widget.bookAuthor,
      bookCoverUrl: widget.bookCoverUrl,
    );

    ref.read(myHighlightsProvider.notifier).add(highlight);
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('문구가 저장되었어요 ✨')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('문구 스크랩'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 정보 표시
            if (widget.bookTitle != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.book, color: theme.colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.bookTitle!, style: theme.textTheme.titleSmall),
                          if (widget.bookAuthor != null)
                            Text(widget.bookAuthor!, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // 문구 입력
            Text('마음에 드는 문구', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _quoteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '책에서 마음에 남은 문구를 적어보세요...',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 내 메모
            Text('나의 생각 (선택)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '이 문구에 대한 나의 생각이나 감상...',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 페이지 번호
            Text('페이지 (선택)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'p.',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 감정 태그
            Text('감정 태그 (선택)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((mood) {
                final selected = _selectedMood == mood;
                return ChoiceChip(
                  label: Text(mood),
                  selected: selected,
                  onSelected: (v) => setState(() => _selectedMood = v ? mood : null),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // AI 성찰 요약 표시
            if (_llmSummary != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: theme.colorScheme.tertiary),
                        const SizedBox(width: 6),
                        Text('AI 성찰 요약', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.tertiary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_llmSummary!, style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // AI 성찰 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  if (_quoteController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('먼저 문구를 입력해주세요')),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReflectionChatScreen(
                        quote: _quoteController.text.trim(),
                        bookTitle: widget.bookTitle ?? '알 수 없는 책',
                        bookAuthor: widget.bookAuthor ?? '',
                        userNote: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                        mood: _selectedMood,
                        onComplete: (conversation, summary) {
                          setState(() {
                            _llmConversation = conversation;
                            _llmSummary = summary;
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(_llmSummary != null ? Icons.refresh : Icons.auto_awesome),
                label: Text(_llmSummary != null ? 'AI 성찰 다시하기' : 'AI와 함께 성찰하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
