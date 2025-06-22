import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // provider 임포트 추가
import 'shared_state.dart';               // 전역 상태 클래스 import

import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedState = SharedState();
  await sharedState.loadData();  // SharedPreferences에서 데이터 로드

  runApp(
    ChangeNotifierProvider.value(
      value: sharedState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '음식 추천 앱',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 3,
          shadowColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Page1(),
    Page2(),
    Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '오늘 뭐 먹지?',
            style: GoogleFonts.bangers(
              color: Colors.green,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 30,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '랜덤 음식'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '내정보'),
        ],
      ),
    );
  }
}
