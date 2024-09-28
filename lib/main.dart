import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'rank.dart'; // 랭킹 페이지 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 기본 인덱스를 랭킹 페이지로 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.table_rows), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: '기록'),
        ],
        onTap: (int idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
        children: [
          RankPage(), // 랭킹 페이지
          MainPage(), // 메인 페이지
          Text("기록 페이지"), // 기록 페이지
        ],
        index: _selectedIndex,
      ),
    );
  }
}
