import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared_state.dart';
import 'food_detail_page.dart';
import 'dart:math';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  int _tappedIndex = -1;
  final Random _random = Random();

  final List<Map<String, dynamic>> categories = [
    {
      'id': 'korean',
      'title': '한식 랜덤 추천',
      'subtitle': '따뜻한 한국의 맛을 중 랜덤으로 느껴봐요',
      'image': 'assets/images/bop.png',
      'color': Colors.redAccent,
    },
    {
      'id': 'chinese',
      'title': '양식 랜덤 추천',
      'subtitle': '고급스럽고 풍부한 양식 요리 오늘은 뭐가 땡기지',
      'image': 'assets/images/burger.png',
      'color': Colors.orangeAccent,
    },
    {
      'id': 'japanese',
      'title': '일식 랜덤 추천',
      'subtitle': '간결하고 정갈한 일식 메뉴 먹고싶다.',
      'image': 'assets/images/sushi.png',
      'color': Colors.indigoAccent,
    },
  ];

  void _showCountDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('추천 개수 선택'),
        content: const Text('몇 개의 음식을 추천받을까요?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _applyRecommendation(index, 5);
            },
            child: const Text('5개'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _applyRecommendation(index, 10);
            },
            child: const Text('10개'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _applyRecommendation(index, 20);
            },
            child: const Text('20개'),
          ),
        ],
      ),
    );
  }

  void _applyRecommendation(int index, int count) {
    final category = categories[index];
    final categoryTitle = category['title'] as String;

    final provider = context.read<SharedState>();

    if (categoryTitle.contains('한식')) {
      provider.setCategory('한식');
    } else if (categoryTitle.contains('양식')) {
      provider.setCategory('양식');
    } else if (categoryTitle.contains('일식')) {
      provider.setCategory('일식');
    }

    provider.setCountAndPick(count);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(
          categoryTitle: categoryTitle,
          onRetry: () {
            provider.retryRecommendation();
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(categories.length, (index) {
            final cat = categories[index];
            final isTapped = _tappedIndex == index;

            return GestureDetector(
              onTapDown: (_) => setState(() => _tappedIndex = index),
              onTapUp: (_) => Future.delayed(
                const Duration(milliseconds: 100),
                    () => setState(() => _tappedIndex = -1),
              ),
              onTapCancel: () => setState(() => _tappedIndex = -1),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: isTapped ? 1.02 : 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          cat['image'],
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['title'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat['subtitle'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _showCountDialog(index),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('시작하기'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cat['color'] as Color,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
