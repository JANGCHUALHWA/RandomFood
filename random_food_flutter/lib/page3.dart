import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'shared_state.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedState = context.watch<SharedState>();

    // 출석 날짜 변환 (yyyy-MM-dd → DateTime)
    final attendanceDates = sharedState.recommendDates.map((d) {
      final parts = d.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toSet();

    final favorites = sharedState.favoriteFoods;
    final coupons = sharedState.couponList;

    // ✅ 날짜와 연결된 즐겨찾기 음식 리스트 만들기 (MM/dd 포맷)
    final List<Map<String, String>> datedFavorites = [];
    sharedState.foodsByDate.forEach((date, foods) {
      for (var food in foods) {
        if (favorites.contains(food)) {
          final mmdd = _formatDateToMMDD(date); // "06/21"
          datedFavorites.add({'food': food, 'date': mmdd});
        }
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📅 출석 달력
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("📅 출석 기록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: DateTime.now(),
                  calendarFormat: CalendarFormat.month,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final date = DateTime(day.year, day.month, day.day);
                      if (attendanceDates.contains(date)) {
                        return Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orangeAccent,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ⭐ 선택 음식 섹션
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("⭐ 선택 음식", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (datedFavorites.isEmpty)
                  const Text("• 선택 음식이 없습니다.", style: TextStyle(fontSize: 16)),
                ...datedFavorites.map((item) => ListTile(
                  title: Text('${item['food']} (${item['date']})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('삭제 확인'),
                          content: Text('${item['food']} 을(를) 선택 목록에서 삭제할까요?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('아니오'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<SharedState>().removeFavorite(item['food']!);
                                Navigator.pop(context);
                              },
                              child: const Text('예'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🎁 보유 쿠폰 섹션
          _section(
            "🎁 보유 쿠폰",
            coupons.isNotEmpty
                ? coupons.map((c) => "- $c").toList()
                : ["- 아직 보유한 쿠폰이 없습니다."],
          ),
        ],
      ),
    );
  }

  // ✅ MM/dd 형식으로 변환 함수
  String _formatDateToMMDD(String date) {
    final parts = date.split('-');
    return '${parts[1].padLeft(2, '0')}/${parts[2].padLeft(2, '0')}';
  }

  // 공통 섹션 (쿠폰 등)
  Widget _section(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((text) => Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
