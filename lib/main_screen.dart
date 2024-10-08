import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:percent_indicator/linear_percent_indicator.dart';

import 'gpt.dart';

enum Category{study, workout, hobby}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final pageController = PageController(initialPage: 0);
  int nowPage = 0;

  Map<String, int> level = {'study': 0, 'workout':0, 'hobby':0};
  Map<String, double> value = {'study': 0.0, 'workout': 0.0, 'hobby': 0.0};
  String cat = "study";

  Dio dio = Dio();
  var response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.options.baseUrl='http://10.223.116.175:8000';
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(minutes: 3);
    dio.options.headers =
    {'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJcdWFlNDBcdWJiZmNcdWMyMTgiLCJleHAiOjEwMzY3NTUwMzUxfQ.zu3i6IMRLMGmG5QSewGGtmb09pTq8H9SgOtxmd6kDcw'};
    _asyncMethod();
  }

  void _asyncMethod() async{
    response = await dio.get('/history/me');
  }

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
              print(level);
              print(value);
            });
            print(nowPage);
          },
          children: [
            // 공부카테고리
            categoryPage(Category.study, context),
            // 운동 카테고리
            categoryPage(Category.workout, context),
            // 취미 카테고리
            categoryPage(Category.hobby, context)
          ]
        )
      ),
    );
  }

  _serverReq() async{
    String tmp = (cat=='workout')? 'exercise' : cat;
    print(response.data);
      int itmp = 0;
      level[cat] = response.data[tmp]['duration']~/480+1;
      itmp =response.data[tmp]['duration'];
      value[cat] = itmp.toDouble()/(480*level[cat]!.toInt());
  }


  Widget categoryPage(Category category, BuildContext context){
    switch(category){
      case Category.study: cat = "study"; break;
      case Category.workout: cat = "workout"; break;
      case Category.hobby: cat = "hobby"; break;
    }
    _serverReq();
    print(cat);
    List<Color> colors = [Color(0xFFFFCE44), Color(0xFF24BB74), Color(0xFF004F9F)];
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
                          "Lv. "+level[cat].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          /*foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white,*/
                        ),
                      ),
                    ),
                    LinearPercentIndicator(
                      width: 300.0,
                      percent: value[cat]!,
                      lineHeight: 20.0,
                      trailing: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                            (level[cat]!+1).toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      barRadius: Radius.circular(30),
                      progressColor: colors[(level[cat]!~/10).clamp(0, colors.length-1)],
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
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=> FastApiExample()));
                      },
                        child: Image.asset('assets/character/'+cat+(level[cat]!.clamp(0, 29)~/10+1).toString()+'.PNG', width: 260,)
                    ),
                    if(category == Category.study || category == Category.workout)
                      IconButton(
                          onPressed: (){
                            pageController.animateToPage(nowPage+1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          },
                          icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,size: 40,)
                      ),
                  ],
                ),
                SizedBox(height: 100), // 적절한 공간 추가
                StopWatch(nowPage: nowPage,), // 타이머 추가
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StopWatch extends StatefulWidget {
  int nowPage;
  StopWatch({required this.nowPage});
  @override
  _StopWatchState createState() => _StopWatchState(this.nowPage);
}

class _StopWatchState extends State<StopWatch> {
  Dio dio = Dio();
  int nowPage;
  _StopWatchState(this.nowPage);
  Timer? _timer; // 타이머
  var _time = 0; // 0.01초마다 1씩 증가시킬 정수형 변수
  var _isRunning = false; // 현재 시작 상태를 나타낼 불리언 변수
  var sec;
  TextEditingController txtDescription = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.options.baseUrl='http://10.223.116.175:8000';
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(seconds: 3);
    dio.options.headers =
    {'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJcdWJiZmNcdWMyYjlcdWQ2MzgiLCJleHAiOjEwMzY3NTU1OTMyfQ.B6PVScPsYPamBA7MvdYHwH4KdrSQ3RjI2DSgnaKS-mA'};
  }
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
      showAlertDialog(context);
      // 서버에 history 보내기.
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
  void _pause() async{
    var response = await dio.post('/history', data: {
      'category' : nowPage+1,
      'duration' : sec,
      'content' : txtDescription.text,
    });
    sec = 0;
    _time = 0;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  // 내용 부분
  Widget _buildBody(BuildContext context) {
    sec = _time ~/ 6000; // 1/100초 단위로 시간을 초로 변환
    String displayText = '$sec XP'; // 타이머에 표시할 텍스트

    return Center(
      child: _isRunning
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayText,
            style: TextStyle(
              fontSize: 32.0,
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
            _isRunning = !_isRunning; // 상태 반전

            if (_isRunning) {
              _start();
            } else {
              showAlertDialog(context);
              // 서버에 history 보내기.
            }
          });
        },
        child: Text('시작하기'),
      ),
    );
  }
  Future<dynamic> showAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('활동 기록 하기'),
            content: SingleChildScrollView(
              child: TextField(
                controller: txtDescription,
                decoration: InputDecoration(hintText: '오늘의 활동을 입력해주세요.'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    txtDescription.text = '';
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    _pause();
                    Navigator.pop(context);
                  },
                  child: Text('submit'),
              )
            ],
          );
        }
    );
  }
}
