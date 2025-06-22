import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'shared_state.dart';

class FoodDetailPage extends StatefulWidget {
  final String categoryTitle;
  final VoidCallback? onRetry;

  const FoodDetailPage({
    super.key,
    required this.categoryTitle,
    this.onRetry,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  bool _revealed = false;
  int _currentIndex = 0;

  final Map<String, Map<String, String>> tempFoodDetails = {
    // 한식
    '김치찌개': {'image': 'assets/images/kimchi.png', 'description': '얼큰하고 깊은 맛의 김치찌개!'},
    '된장찌개': {'image': 'assets/images/denjang.png', 'description': '구수한 맛의 대표 찌개!'},
    '불고기': {'image': 'assets/images/bulgogi.png', 'description': '달콤 짭짤한 고기요리!'},
    '비빔밥': {'image': 'assets/images/bop.png', 'description': '채소와 고추장의 조화로운 만남!'},
    '제육볶음': {'image': 'assets/images/jeyuk.png', 'description': '매콤한 돼지고기 볶음!'},
    '삼겹살': {'image': 'assets/images/samgyeopsal.png', 'description': '구워 먹는 최고의 고기!'},
    '갈비탕': {'image': 'assets/images/galbitang.png', 'description': '고소하고 든든한 국물 맛!'},
    '닭갈비': {'image': 'assets/images/dakgalbi.png', 'description': '매콤달콤한 닭고기 요리!'},
    '부대찌개': {'image': 'assets/images/budae.png', 'description': '다양한 재료의 얼큰한 찌개!'},
    '감자탕': {'image': 'assets/images/gamjatang.png', 'description': '등뼈와 감자의 깊은 맛!'},
    '순두부찌개': {'image': 'assets/images/soontofu.png', 'description': '부드러운 순두부와 얼큰한 국물!'},
    '오징어볶음': {'image': 'assets/images/squid.png', 'description': '매콤한 오징어와 야채의 조화!'},
    '떡갈비': {'image': 'assets/images/tteokgalbi.png', 'description': '쫄깃하고 달콤한 갈비 맛!'},
    '쭈꾸미볶음': {'image': 'assets/images/jjukkumi.png', 'description': '매콤한 해산물 요리!'},
    '소불고기': {'image': 'assets/images/sobulgogi.png', 'description': '부드러운 소고기 볶음!'},
    '해장국': {'image': 'assets/images/haejangguk.png', 'description': '숙취에 좋은 진한 국물!'},
    '파전': {'image': 'assets/images/pajeon.png', 'description': '비 오는 날의 대표 메뉴!'},
    '콩나물국밥': {'image': 'assets/images/kongnamul.png', 'description': '시원한 국물의 아침 한끼!'},
    '잡채': {'image': 'assets/images/japchae.png', 'description': '당면과 야채의 완벽한 조화!'},
    '비빔국수': {'image': 'assets/images/bibimnoodle.png', 'description': '매콤 새콤한 여름 별미!'},

    // 양식 (기존 중식 키 위치에 대체)
    '스테이크': {'image': 'assets/images/steak.png', 'description': '육즙 가득한 고급 요리!'},
    '파스타': {'image': 'assets/images/pasta.png', 'description': '크림, 토마토, 오일 어떤 맛도 완벽!'},
    '피자': {'image': 'assets/images/pizza.png', 'description': '치즈와 토핑의 환상적인 조화!'},
    '햄버거': {'image': 'assets/images/burger.png', 'description': '한 입에 넣기 아까운 두툼한 맛!'},
    '리조또': {'image': 'assets/images/risotto.png', 'description': '부드러운 쌀과 진한 소스의 맛!'},
    '로스트치킨': {'image': 'assets/images/roastchicken.png', 'description': '겉은 바삭, 속은 촉촉한 치킨!'},
    '라자냐': {'image': 'assets/images/lasagna.png', 'description': '치즈와 고기의 층층이 향연!'},
    '크림수프': {'image': 'assets/images/creamsoup.png', 'description': '부드럽고 진한 풍미의 수프!'},
    '클램차우더': {'image': 'assets/images/clamchowder.png', 'description': '조개와 감자의 진한 맛!'},
    '샐러드': {'image': 'assets/images/salad.png', 'description': '신선한 채소로 가볍게 한끼!'},
    '샌드위치': {'image': 'assets/images/sandwich.png', 'description': '간편하고 맛있는 서양식 한끼!'},
    '프렌치토스트': {'image': 'assets/images/frenchtoast.png', 'description': '계란과 시럽의 달콤한 조화!'},
    '감바스': {'image': 'assets/images/gambas.png', 'description': '올리브 오일과 마늘 새우의 풍미!'},
    '브런치': {'image': 'assets/images/brunch.png', 'description': '여유로운 아침을 위한 한 접시!'},
    '베이컨에그': {'image': 'assets/images/baconegg.png', 'description': '고소한 베이컨과 부드러운 달걀!'},
    '치킨텐더': {'image': 'assets/images/chickentender.png', 'description': '부드럽고 바삭한 닭가슴살 튀김!'},
    '치즈오븐스파게티': {'image': 'assets/images/cheesespaghetti.png', 'description': '치즈 듬뿍 오븐에 구운 스파게티!'},
    '오믈렛': {'image': 'assets/images/omelette.png', 'description': '폭신한 계란 안에 가득찬 속재료!'},
    '베이글샌드위치': {'image': 'assets/images/bagelsandwich.png', 'description': '든든하고 탄력 있는 아침 식사!'},
    '미트볼스파게티': {'image': 'assets/images/meatballpasta.png', 'description': '큼직한 미트볼과 진한 소스의 조화!'},


    // 일식
    '초밥': {'image': 'assets/images/sushi.png', 'description': '신선한 생선과 밥의 조화!'},
    '우동': {'image': 'assets/images/udon.png', 'description': '굵고 쫄깃한 면발의 국수!'},
    '라멘': {'image': 'assets/images/ramen.png', 'description': '진한 국물과 고명의 일본식 국수!'},
    '규동': {'image': 'assets/images/gyudon.png', 'description': '달콤한 양념의 소고기 덮밥!'},
    '가츠동': {'image': 'assets/images/katsudon.png', 'description': '바삭한 돈카츠와 부드러운 계란!'},
    '돈카츠': {'image': 'assets/images/tonkatsu.png', 'description': '두툼한 고기의 바삭한 튀김!'},
    '오므라이스': {'image': 'assets/images/omurice.png', 'description': '부드러운 계란과 케첩 볶음밥!'},
    '타코야끼': {'image': 'assets/images/takoyaki.png', 'description': '문어가 들어간 바삭한 간식!'},
    '야끼소바': {'image': 'assets/images/yakisoba.png', 'description': '볶음면의 진수!'},
    '가라아게': {'image': 'assets/images/karaage.png', 'description': '바삭한 일본식 닭튀김!'},
    '덴푸라': {'image': 'assets/images/tempura.png', 'description': '바삭하게 튀긴 해산물과 채소!'},
    '사케동': {'image': 'assets/images/sakedon.png', 'description': '연어회가 듬뿍 올라간 덮밥!'},
    '야키니쿠': {'image': 'assets/images/yakiniku.png', 'description': '불향 가득한 소고기 구이!'},
    '스키야키': {'image': 'assets/images/sukiyaki.png', 'description': '달짝지근한 전골 요리!'},
    '나베': {'image': 'assets/images/nabe.png', 'description': '따뜻하고 푸짐한 일본식 전골!'},
    '일본식카레': {'image': 'assets/images/japanesecurry.png', 'description': '달콤하고 부드러운 카레 맛!'},
    '오코노미야끼': {'image': 'assets/images/okonomiyaki.png', 'description': '일본식 부침개의 진수!'},
    '소바': {'image': 'assets/images/soba.png', 'description': '메밀향 가득한 시원한 면요리!'},
    '연어덮밥': {'image': 'assets/images/salmonbowl.png', 'description': '신선한 연어와 밥의 조화!'},
    '에비동': {'image': 'assets/images/ebidon.png', 'description': '튀김 새우가 올라간 덮밥!'},

  };

  void _nextCard(SharedState state) {
    if (_currentIndex < state.selectedFoods.length - 1) {
      setState(() {
        _currentIndex++;
        _revealed = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('선택한 모든 추천을 확인했어요!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedState = context.watch<SharedState>();
    final foods = sharedState.selectedFoods;
    final food = foods[_currentIndex];
    final foodInfo = tempFoodDetails[food];
    final imagePath = foodInfo?['image'] ?? '';
    final description = foodInfo?['description'] ?? '이 음식은 정말 맛있고 건강에 좋아요!';
    final isFavorite = sharedState.favoriteFoods.contains(food);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),

      ),
      body: Center(
        child: !_revealed
            ? SizedBox(
          width: 250,
          height: 300,
          child: Lottie.asset(
            'assets/animations/present.json',
            fit: BoxFit.contain,
            repeat: false,
            animate: true,
            onLoaded: (composition) {
              final fastDuration = composition.duration * 0.5;
              Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                  _revealed = true;
                });
              });
            },
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath.isNotEmpty)
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 12),
              Text(
                food,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(isFavorite ? '선택 목록 해제' : '선택 목록 선택'),
                onPressed: () {
                  if (isFavorite) {
                    sharedState.removeFavorite(food);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$food 선택 목록 에서 해제됨')),
                    );
                  } else {
                    sharedState.addFavorite(food);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$food 선택 목록 에서 추가됨')),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _nextCard(sharedState),
                child: const Text('다음 추천 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
