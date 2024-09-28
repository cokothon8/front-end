import 'package:flutter/material.dart';
import 'dart:async';

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
    return SizedBox.expand(
      child: Column(
        children: [
          // 카테고리 이름
          if(category == Category.study)
            Text("공부", style: TextStyle(fontSize: 18),),
          if(category == Category.workout)
            Text("운동", style: TextStyle(fontSize: 18),),
          if(category == Category.hobby)
            Text("취미", style: TextStyle(fontSize: 18),),
          //쿠민이 이미지
          
          Spacer(),
          Row(
            children: [
              if(category == Category.workout || category == Category.hobby)
                IconButton(
                  onPressed: (){
                    pageController.animateToPage(nowPage-1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                  },
                  icon: Icon(Icons.arrow_back_ios_new)
                ),
              // 이미지 위치
              Spacer(),
              if(category == Category.study || category == Category.workout)
                IconButton(
                  onPressed: (){
                    pageController.animateToPage(nowPage+1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                  },
                  icon: Icon(Icons.arrow_forward_ios)
                ),
            ],
          ),
          SizedBox(height: 20,),
          // progressBar
          SizedBox(height: 30,),

          // 시작버튼
          ElevatedButton(
            onPressed: (){},
            child: Text("시작"),
          )


        ],
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
  void dispose() { // 앱을 종료할 때 반복되는 동작 취소
    _timer?.cancel();
    super.dispose();
  }

  void _clickButton() {
    _isRunning = !_isRunning; // 상태 반전

    if(_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  // 타이머 시작 1/100초에 한 번씩 time 변수를 1증가
  void _start() {
    _timer = Timer.periodic(Duration(milliseconds:10), (timer) {
      setState((){
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            setState(() {
              _clickButton();
            }),
        child: _isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  //내용 부분

  Widget _buildBody() {
    var sec = _time ~/ 100; //초
    var hundredth = '${_time % 100}'.padLeft(2, '0'); // 1/100초

    return Center(
      child:
        Row( // 시간을 표시하는 영역
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:<Widget>[
            Text(
              '$sec',
              style: TextStyle(fontSize:70.0),
            ),
            Text('$hundredth', style:TextStyle(fontSize:20)), // 1/100초
        ],
      )
    );
  }
}