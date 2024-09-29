import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Image.asset('assets/solar_ranking-linear.png'), label: ''),
          BottomNavigationBarItem(icon: Image.asset('assets/home_icon.png'), label: ''),
          BottomNavigationBarItem(icon: Image.asset('assets/record.png'), label: '')
        ],
        onTap: (int idx){
          setState(() {
            _selectedIndex = idx;
          });
        },
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
          children: [
            // 페이지 전 테스트페이지
            Text("랭킹페이지"),
            MainPage(), // 메인페이지
            Text("기록페이지"),
            /*RankPage(), // 랭킹페이지
            RecordPage() // 기록페이지*/
          ],
        index: _selectedIndex,
      ),
    );
  }
}
