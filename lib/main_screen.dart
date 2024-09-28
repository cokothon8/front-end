import 'package:flutter/material.dart';
import 'dart:async';

import 'package:percent_indicator/linear_percent_indicator.dart';

enum Category{study, workout, hobby}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final pageController = PageController(initialPage: 0);
  int nowPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Image.asset('assets/logo.png'),
        ),
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: pageController,
          onPageChanged: (index){
            setState(() {
              nowPage = index;
            });
            print(nowPage);
          },
          children: [
            // 공부카테고리
            categoryPage(Category.study),
            // 운동 카테고리
            categoryPage(Category.workout),
            // 취미 카테고리
            categoryPage(Category.hobby)
          ]
        )
      ),
    );
  }


  Widget categoryPage(Category category){
    String cat = "";
    switch(category){
      case Category.study: cat = "study"; break;
      case Category.workout: cat = "workout"; break;
      case Category.hobby: cat = "hobby"; break;
    }
    print(cat);
    List<Color> colors = [Color(0xFFFFCE44), Color(0xFF24BB74), Color(0xFF004F9F)];
    double value = 0.5;
    int level = 20;
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage('assets/'+cat+'_bg.png'),
            fit: BoxFit.fill
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Lv. "+level.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    LinearPercentIndicator(
                      width: 300.0,
                      percent: value,
                      lineHeight: 20.0,
                      trailing: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                            (level+1).toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      barRadius: Radius.circular(30),
                      progressColor: colors[(level~/10)%3],
                    )
                  ],
                ),
                Row(
                  children: [
                    // 왼쪽 오른쪽 화면 넘기기 아이콘
                    if(category == Category.workout || category == Category.hobby)
                      IconButton(
                          onPressed: (){
                            pageController.animateToPage(nowPage-1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,size: 40,)
                      ),
                    if(category == Category.study) Spacer(),
                    // 이미지 위치
                    Image.asset('assets/character/'+cat+(level~/10+1).toString()+'.PNG', width: 270,),
                    if(category == Category.study || category == Category.workout)
                      IconButton(
                          onPressed: (){
                            pageController.animateToPage(nowPage+1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          },
                          icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,size: 40,)
                      ),
                  ],
                ),
                SizedBox(height: 130), // 적절한 공간 추가
                StopWatch(), // 타이머 추가
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  Timer? _timer; // 타이머
  var _time = 0; // 0.01초마다 1씩 증가시킬 정수형 변수
  var _isRunning = false; // 현재 시작 상태를 나타낼 불리언 변수

  List<String> _lapTimes = []; // 랩타임에 표시할 시간을 저장할 리스트

  @override
  void dispose() {
    // 앱을 종료할 때 반복되는 동작 취소
    _timer?.cancel();
    super.dispose();
  }

  void _clickButton() {
    _isRunning = !_isRunning; // 상태 반전

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  // 타이머 시작 1/100초에 한 번씩 time 변수를 1증가
  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  // 타이머 취소
  void _pause() {
    _timer?.cancel();
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, time); // 시간 리스트에 추가
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  // 내용 부분
  Widget _buildBody() {
    var sec = _time ~/ 6000; // 1/100초 단위로 시간을 초로 변환
    String displayText = '$sec EXP'; // 타이머에 표시할 텍스트

    return Center(
      child: _isRunning
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayText,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.pause_circle_filled,
              size: 45.0,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _clickButton();
              });
            },
          ),
        ],
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          minimumSize: Size(300, 60),
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        onPressed: () {
          setState(() {
            _clickButton();
          });
        },
        child: Text('시작하기'),
      ),
    );
  }
}
