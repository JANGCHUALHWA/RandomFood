import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final foodCategories = [
      {
        'title': '한식',
        'image': 'assets/images/bop.png',
      },
      {
        'title': '양식',
        'image': 'assets/images/burger.png',
      },
      {
        'title': '일식',
        'image': 'assets/images/sushi.png',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 8, right: 8, bottom: 24),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: foodCategories.length,
                itemBuilder: (context, index, realIndex) {
                  final item = foodCategories[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 240, // 카드 이미지 높이 증가
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: item['image']!.startsWith('http')
                                ? Image.network(
                              item['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.broken_image, size: 20));
                              },
                            )
                                : Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 26, // 텍스트 크기도 살짝 증가
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 300, // 전체 카드 높이 증가
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3), //3초 간격
                  viewportFraction: 1.0,
                ),
              ),
              const SizedBox(height: 30),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '공지사항',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '''- 새로운 음식 카테고리가 곧 추가됩니다!
                                - 앱 버전 1.1 업데이트 완료
                             - 서버 점검 안내: 6월 5일 오후 10시부터
                           

''',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이벤트',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '''- 배민 쿠폰 50% 할인 이벤트 진행중!
                                 - 친구 초대하면 추가 쿠폰 증정!
                                 


''',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
