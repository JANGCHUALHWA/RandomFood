import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, List<String>> allFoodsByCategory = {
  '한식': [
    '김치찌개', '된장찌개', '불고기', '비빔밥', '제육볶음',
    '삼겹살', '갈비탕', '닭갈비', '부대찌개', '감자탕',
    '순두부찌개', '오징어볶음', '떡갈비', '쭈꾸미볶음', '소불고기',
    '해장국', '파전', '콩나물국밥', '잡채', '비빔국수',
  ],
  '양식': [
    '스테이크', '파스타', '피자', '햄버거', '리조또',
    '로스트치킨', '라자냐', '크림수프', '클램차우더', '샐러드',
    '샌드위치', '프렌치토스트', '감바스', '브런치', '베이컨에그',
    '치킨텐더', '치즈오븐스파게티', '오믈렛', '베이글샌드위치', '미트볼스파게티',
  ],
  '일식': [
    '초밥', '우동', '라멘', '규동', '가츠동',
    '돈카츠', '오므라이스', '타코야끼', '야끼소바', '가라아게',
    '덴푸라', '사케동', '야키니쿠', '스키야키', '나베',
    '일본식카레', '오코노미야끼', '소바', '연어덮밥', '에비동',
  ],
};

class SharedState extends ChangeNotifier {
  List<String> favoriteFoods = [];
  List<String> recommendDates = [];
  List<Map<String, String>> couponList = [];
  String selectedCategory = '한식';
  int selectedCount = 5;
  List<String> selectedFoods = [];
  Map<String, List<String>> recentRecommendedFoodsByCategory = {};

  // ✅ 날짜별 추천 음식 저장
  Map<String, List<String>> foodsByDate = {};

  int retryCount = 0;
  int maxRetry = 5;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteFoods = prefs.getStringList('favorites') ?? [];
    recommendDates = prefs.getStringList('dates') ?? [];

    final rawCoupons = prefs.getStringList('coupons') ?? [];
    couponList = rawCoupons.map((c) => Map<String, String>.from(jsonDecode(c))).toList();

    final rawRecent = prefs.getString('recentRecommendedFoods') ?? '{}';
    recentRecommendedFoodsByCategory = Map<String, List<String>>.from(
      (jsonDecode(rawRecent) as Map).map(
            (key, value) => MapEntry(key as String, List<String>.from(value)),
      ),
    );

    // ✅ 날짜별 추천 음식 로딩
    final rawFoodsByDate = prefs.getString('foodsByDate') ?? '{}';
    foodsByDate = Map<String, List<String>>.from(
      (jsonDecode(rawFoodsByDate) as Map).map(
            (key, value) => MapEntry(key as String, List<String>.from(value)),
      ),
    );

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoriteFoods);
    await prefs.setStringList('dates', recommendDates);
    final rawCoupons = couponList.map((c) => jsonEncode(c)).toList();
    await prefs.setStringList('coupons', rawCoupons);
    await prefs.setString('recentRecommendedFoods', jsonEncode(recentRecommendedFoodsByCategory));

    // ✅ 날짜별 추천 음식 저장
    await prefs.setString('foodsByDate', jsonEncode(foodsByDate));
  }

  void addFavorite(String food) {
    if (!favoriteFoods.contains(food)) {
      favoriteFoods.add(food);
      _saveData();
      notifyListeners();
    }
  }

  void removeFavorite(String food) {
    if (favoriteFoods.contains(food)) {
      favoriteFoods.remove(food);
      _saveData();
      notifyListeners();
    }
  }

  void addDate(String date) {
    if (!recommendDates.contains(date)) {
      recommendDates.add(date);
      _saveData();
      notifyListeners();
      _checkAndGive4WeekCoupon();
    }
  }

  void _checkAndGive4WeekCoupon() {
    final now = DateTime.now();
    final recent28Days = List.generate(28, (i) => now.subtract(Duration(days: i)));

    final recentAttendance = recommendDates.where((d) {
      final parsed = DateTime.tryParse(d.replaceAll('.', '-'));
      return parsed != null &&
          recent28Days.any((r) => r.year == parsed.year && r.month == parsed.month && r.day == parsed.day);
    }).toList();

    if (recentAttendance.length >= 28) {
      addCoupon(
        '🎁 4주 출석 쿠폰',
        now,
        now.add(const Duration(days: 7)),
      );
    }
  }

  void addCoupon(String name, DateTime issuedDate, DateTime expiryDate) {
    final newCoupon = {
      'name': name,
      'issuedDate': issuedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
    };

    final exists = couponList.any((c) => c['name'] == name);
    if (!exists) {
      couponList.add(newCoupon);
      _saveData();
      notifyListeners();
    }
  }

  void addRecentRecommendation(String category, String food) {
    if (!recentRecommendedFoodsByCategory.containsKey(category)) {
      recentRecommendedFoodsByCategory[category] = [];
    }
    if (!recentRecommendedFoodsByCategory[category]!.contains(food)) {
      recentRecommendedFoodsByCategory[category]!.add(food);
      _saveData();
      notifyListeners();
    }
  }

  void clearRecentRecommendations(String category) {
    recentRecommendedFoodsByCategory[category]?.clear();
    _saveData();
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setCountAndPick(int count) {
    selectedCount = count;
    maxRetry = count;
    retryCount = 0;

    final list = [...?allFoodsByCategory[selectedCategory]];
    list.shuffle();
    selectedFoods = list.take(count).toList();

    final now = DateTime.now();
    final dateKey = "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // ✅ 기존 음식들과 중복 없이 누적 저장
    final existingFoods = foodsByDate[dateKey] ?? [];
    foodsByDate[dateKey] = {
      ...existingFoods,
      ...selectedFoods,
    }.toList(); // Set으로 중복 제거 후 리스트화

    addDate(dateKey);
    notifyListeners();
    _saveData();
  }

  void retryRecommendation() {
    if (retryCount < maxRetry) {
      final list = [...?allFoodsByCategory[selectedCategory]];
      list.shuffle();
      selectedFoods = list.take(selectedCount).toList();
      retryCount++;
      notifyListeners();
    }
  }

  bool get canRetry => retryCount < maxRetry;

  void resetRetry(int count) {
    retryCount = 0;
    maxRetry = count;
  }
}
