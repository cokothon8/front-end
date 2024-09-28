import 'package:flutter/material.dart';
import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
      ),
      body: _buildBody(),
    );
  }
  //내용 부분

  Widget _buildBody() {
    // String start = '시작';
    var sec = _time ~/ 100; //
    String buttonText = _isRunning ? '$sec EXP' : '시작'; // 버튼 텍스트 상태에 따라 설정

    return Center(
      child: ElevatedButton(
              // child: Text('$start'),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(	//모서리를 둥글게
              borderRadius: BorderRadius.circular(20)),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () => {
                setState(() {
                _clickButton();
              })
              },
              child: Text('$buttonText')
      ),
    );
  }
}