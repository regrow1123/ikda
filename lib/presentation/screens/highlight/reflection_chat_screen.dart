import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/gemini_service.dart';

class ReflectionChatScreen extends ConsumerStatefulWidget {
  final String quote;
  final String bookTitle;
  final String bookAuthor;
  final String? userNote;
  final String? mood;
  final void Function(List<Map<String, dynamic>> conversation, String summary) onComplete;

  const ReflectionChatScreen({
    super.key,
    required this.quote,
    required this.bookTitle,
    required this.bookAuthor,
    this.userNote,
    this.mood,
    required this.onComplete,
  });

  @override
  ConsumerState<ReflectionChatScreen> createState() => _ReflectionChatScreenState();
}

class _ReflectionChatScreenState extends ConsumerState<ReflectionChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startReflection();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startReflection() async {
    setState(() => _isLoading = true);
    try {
      final questions = await GeminiService.generateReflectionQuestions(
        quote: widget.quote,
        bookTitle: widget.bookTitle,
        bookAuthor: widget.bookAuthor,
        userNote: widget.userNote,
        mood: widget.mood,
      );
      setState(() {
        _messages.add({'role': 'model', 'text': questions});
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({'role': 'model', 'text': '성찰 질문을 생성하지 못했어요. 다시 시도해주세요.'});
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    _controller.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await GeminiService.continueConversation(
        history: _messages.sublist(0, _messages.length - 1),
        userMessage: text,
      );
      setState(() {
        _messages.add({'role': 'model', 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({'role': 'model', 'text': '응답 생성에 실패했어요.'});
        _isLoading = false;
      });
    }
  }

  Future<void> _finishReflection() async {
    setState(() => _isLoading = true);
    try {
      final summary = await GeminiService.generateSummary(
        quote: widget.quote,
        conversation: _messages,
      );
      widget.onComplete(_messages, summary);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('성찰이 저장되었어요 ✨')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('요약 생성에 실패했어요')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 성찰'),
        actions: [
          if (_messages.where((m) => m['role'] == 'user').isNotEmpty)
            TextButton.icon(
              onPressed: _isLoading ? null : _finishReflection,
              icon: const Icon(Icons.check),
              label: const Text('완료'),
            ),
        ],
      ),
      body: Column(
        children: [
          // 원문 인용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(color: theme.colorScheme.primary, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.quote,
                  style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '— ${widget.bookTitle}',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),

          // 대화 영역
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('생각하는 중...'),
                      ],
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUser ? theme.colorScheme.onPrimary : null,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 입력 바
          if (!_isComplete)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -1))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: '생각을 나눠보세요...',
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _isLoading ? null : _sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
