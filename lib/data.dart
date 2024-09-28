import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(BarChartSample());

class BarChartSample extends StatefulWidget {
  @override
  _BarChartSampleState createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  int selectedGraph = 0; // 0: 첫 번째 그래프 (주간), 1: 두 번째 그래프 (월간)

  final Dio dio = Dio();

  // 주간 데이터를 위한 변수 선언
  int weeklyMaxValue = 0;
  int weeklyAverageValue = 0;
  int weeklyMonday = 0;
  int weeklyTuesday = 0;
  int weeklyWednesday = 0;
  int weeklyThursday = 0;
  int weeklyFriday = 0;
  int weeklySaturday = 0;
  int weeklySunday = 0;
  int weeklyStudyTotal = 0;
  int weeklyExerciseTotal = 0;
  int weeklyHobbyTotal = 0;

  // 월간 데이터를 위한 변수 선언
  int monthlyMaxValue = 0;
  int monthlyAverageValue = 0;
  int monthlyStudyTotal = 0;
  int monthlyExerciseTotal = 0;
  int monthlyHobbyTotal = 0;

  int experienceStudyTotal = 0;
  int experienceExerciseTotal = 0;
  int experienceHobbyTotal = 0;
  int experienceMaxCategory = 0;
  String maxCategory = "";

  String errorMessage = "Loading...";

  // 서버에서 받은 토큰 값
  String accessToken = "";
  String refreshToken = "";
  String tokenType = "Bearer"; // 보통 Bearer로 고정

  Future<void> fetchData() async {
    try {
      // 토큰 값 설정 (여기에 실제 토큰 값 추가)
      Map<String, dynamic> tokenResponse = {
        "access_token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJcdWM3NzRcdWIzZDlcdWM1YjgiLCJleHAiOjEwMzY3NTUwNjc2fQ.TtIQgGUgajZdjRXyFe3qSf19m2mmsAd-9PIWyU_bqDI",
        "token_type": "Bearer",
        "refresh_token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJcdWM3NzRcdWIzZDlcdWM1YjgiLCJleHAiOjE3NTkwODY2NzZ9.u6dZ0PcGfIAmlwK5y3kjR8PS8ZVcWWVSY0DR068nzOk"
      };

      // 토큰 값을 설정
      setState(() {
        accessToken = tokenResponse["access_token"];
        refreshToken = tokenResponse["refresh_token"];
        tokenType = tokenResponse["token_type"];
      });

      // 주간 데이터 요청
      Response weeklyResponse = await dio.get(
        "http://10.223.116.175:8000/history/weekly?year=2024&month=9&week=4",
        options: Options(
          headers: {
            "Authorization": "$tokenType $accessToken",
          },
        ),
      );

      // 경험 데이터 요청
      Response experience = await dio.get(
        "http://10.223.116.175:8000/history/experience",
        options: Options(
          headers: {
            "Authorization": "$tokenType $accessToken",
          },
        ),
      );

      // 월간 데이터 요청
      Response monthlyResponse = await dio.get(
        "http://10.223.116.175:8000/history/monthly?year=2024",
        options: Options(
          headers: {
            "Authorization": "$tokenType $accessToken",
          },
        ),
      );

      // 주간 데이터를 처리
      if (weeklyResponse.statusCode == 200) {
        Map<String, dynamic> weeklyData = weeklyResponse.data;

        setState(() {
          weeklyMaxValue = int.parse(weeklyData['max'].toString());
          weeklyAverageValue = int.parse(weeklyData['average'].toString());
          weeklyMonday = int.parse(weeklyData['monday'].toString());
          weeklyTuesday = int.parse(weeklyData['tuesday'].toString());
          weeklyWednesday = int.parse(weeklyData['wednesday'].toString());
          weeklyThursday = int.parse(weeklyData['thursday'].toString());
          weeklyFriday = int.parse(weeklyData['friday'].toString());
          weeklySaturday = int.parse(weeklyData['saturday'].toString());
          weeklySunday = int.parse(weeklyData['sunday'].toString());
          weeklyStudyTotal = int.parse(weeklyData['study_total'].toString());
          weeklyExerciseTotal = int.parse(weeklyData['exercise_total'].toString());
          weeklyHobbyTotal = int.parse(weeklyData['hobby_total'].toString());

          // 주간 데이터를 기반으로 firstGraphData 업데이트
          firstGraphData = [
            BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                      toY: weeklyMonday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                      toY: weeklyTuesday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                      toY: weeklyWednesday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                      toY: weeklyThursday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                      toY: weeklyFriday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 5,
                barRods: [
                  BarChartRodData(
                      toY: weeklySaturday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
            BarChartGroupData(
                x: 6,
                barRods: [
                  BarChartRodData(
                      toY: weeklySunday.toDouble(),
                      color: Colors.orange,
                      width: 15)
                ]),
          ];
        });
      }

      // 월간 데이터를 처리
      if (monthlyResponse.statusCode == 200) {
        Map<String, dynamic> monthlyData = monthlyResponse.data;
        List<dynamic> monthList = monthlyData['months'];

        setState(() {
          monthlyAverageValue = int.parse(monthlyData['average'].toString());
          monthlyMaxValue = int.parse(monthlyData['max'].toString());
          monthlyStudyTotal = int.parse(monthlyData['study_total'].toString());
          monthlyExerciseTotal =
              int.parse(monthlyData['exercise_total'].toString());
          monthlyHobbyTotal = int.parse(monthlyData['hobby_total'].toString());

          // 월간 데이터를 기반으로 secondGraphData 업데이트
          secondGraphData = List.generate(monthList.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    toY: monthList[index].toDouble(),
                    color: Colors.orange,
                    width: 15)
              ],
            );
          });
        });
      }

      // 경험 데이터를 처리
      if (experience.statusCode == 200) {
        Map<String, dynamic> experienceData = experience.data;

        setState(() {
          experienceStudyTotal = int.parse(experienceData['study_total'].toString());
          experienceExerciseTotal = int.parse(experienceData['exercise_total'].toString());
          experienceHobbyTotal = int.parse(experienceData['hobby_total'].toString());
          experienceMaxCategory = int.parse(experienceData['max_category'].toString());

          // 상태 관리에서 카테고리 값을 업데이트
          if (experienceMaxCategory == 1) {
            maxCategory = "공부";
          } else if (experienceMaxCategory == 2) {
            maxCategory = "운동";
          } else if (experienceMaxCategory == 3) {
            maxCategory = "취미";
          } else {
            maxCategory = "알 수 없음";
          }
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data: $e";
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchData(); // 데이터를 받아오는 함수 호출
  }

  List<BarChartGroupData> firstGraphData = [];
  List<BarChartGroupData> secondGraphData = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text('기록'))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 42.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '닉네임 님 \n오늘은 얼마나 성장하셨나요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2024년 9월 30일',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    width: 320,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      TextBox('역대 최고 공부 EXP \n$experienceStudyTotal'),
                      SizedBox(height: 8),
                      TextBox('역대 최고 취미 EXP \n$experienceHobbyTotal'),
                    ],
                  ),
                  Column(
                    children: [
                      TextBox('역대 최고 운동 EXP \n$experienceExerciseTotal'),
                      SizedBox(height: 8),
                      TextBox('역대 최고 카테고리 \n$maxCategory'),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 30,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffE6E1D8),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedGraph = 0;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedGraph == 0
                            ? Colors.white
                            : Color(0xffE6E1D8),
                        foregroundColor: Colors.black,
                        padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      ),
                      child: Text("Weekly", style: TextStyle(fontSize: 10)),
                    ),
                    SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedGraph = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedGraph == 1
                            ? Colors.white
                            : Color(0xffE6E1D8),
                        foregroundColor: Colors.black,
                        padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      ),
                      child: Text('Monthly', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: selectedGraph == 0
                          ? firstGraphData
                          : secondGraphData,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: false,
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              );
                              if (selectedGraph == 0) {
                                List<String> days = [
                                  'Sun',
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat'
                                ];
                                return Text(days[value.toInt()], style: style);
                              } else {
                                return Text((value.toInt() + 1).toString(),
                                    style: style);
                              }
                            },
                          ),
                        ),
                        rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // 수정된 텍스트 박스 부분
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextBox(
                        selectedGraph == 0
                            ? '평균 시간\n$weeklyAverageValue' // weeklyResponse에서 가져옴
                            : '평균 시간\n$monthlyAverageValue', // monthlyResponse에서 가져옴
                      ),
                      SizedBox(width: 16),
                      TextBox(
                        selectedGraph == 0
                            ? '최대 시간\n$weeklyMaxValue' // weeklyResponse에서 가져옴
                            : '최대 시간\n$monthlyMaxValue', // monthlyResponse에서 가져옴
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextBox(
                        selectedGraph == 0
                            ? '공부 시간\n$weeklyStudyTotal' // weeklyResponse에서 가져옴
                            : '공부 시간\n$monthlyStudyTotal', // monthlyResponse에서 가져옴
                      ),
                      SizedBox(width: 16),
                      TextBox(
                        selectedGraph == 0
                            ? '운동 시간\n$weeklyExerciseTotal' // weeklyResponse에서 가져옴
                            : '운동 시간\n$monthlyExerciseTotal', // monthlyResponse에서 가져옴
                      ),
                      SizedBox(width: 16),
                      TextBox(
                        selectedGraph == 0
                            ? '취미 시간\n$weeklyHobbyTotal' // weeklyResponse에서 가져옴
                            : '취미 시간\n$monthlyHobbyTotal', // monthlyResponse에서 가져옴
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String text;

  TextBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
