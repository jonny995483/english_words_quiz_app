import 'package:english_words_quiz_app/screens/wordbook/word_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';
import '../services/quiz_state_service.dart';

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({super.key});

  @override
  State<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends State<WordbookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: Consumer<QuizStateService>(
          builder: (context, quizState, child) {
            final filteredWords = quizState.myWords.where((word) {
              final wordLower = word.word.toLowerCase();
              final meaningLower = word.meaning.toLowerCase();
              final searchLower = _searchQuery.toLowerCase();
              return wordLower.contains(searchLower) ||
                  meaningLower.contains(searchLower);
            }).toList();

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.deepPurple.shade200.withOpacity(0.5),
                  expandedHeight: 120.0,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text('나만의 단어장',
                        style: TextStyle(color: Colors.black87)),
                    centerTitle: true,
                  ),
                ),
                SliverToBoxAdapter(child: _buildSearchBar()),
                if (filteredWords.isEmpty)
                  SliverFillRemaining(child: _buildEmptyView())
                else
                  _buildWordList(filteredWords),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WordEditScreen()),
          );
        },
        backgroundColor: Colors.deepPurple[400],
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: '새 단어 추가',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Card(
        elevation: 2.0,
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '단어 또는 뜻으로 검색',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined,
              size: 80, color: Colors.deepPurple.shade200),
          const SizedBox(height: 20),
          Text(
            '저장된 단어가 없습니다.\n아래 + 버튼으로 새 단어를 추가해보세요!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildWordList(List<Word> words) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final word = words[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0), // 마진 조정
            child: Card(
              margin: EdgeInsets.zero, // CardTheme의 마진을 사용하지 않으므로 여기서 0으로 설정
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(word.word,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                subtitle: Text(word.meaning,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black54)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => WordEditScreen(word: word)),
                  );
                },
                trailing: IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmDialog(context, word),
                ),
              ),
            ),
          );
        },
        childCount: words.length,
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Word word) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('단어 삭제'),
          content: Text("'${word.word}' 단어를 정말 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<QuizStateService>().deleteMyWord(word.id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
