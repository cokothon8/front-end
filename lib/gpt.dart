import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FastApiExample extends StatefulWidget {
  @override
  _FastApiExampleState createState() => _FastApiExampleState();
}

class _FastApiExampleState extends State<FastApiExample> {
  String studyMessage = "";
  String exerciseMessage = "";
  String hobbyMessage = "";
  String jwtToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJcdWM3NzRcdWIzZDlcdWM1YjgiLCJleHAiOjEwMzY3NTY3NzA3fQ.w-rRzFVHCINEsaWUtC_Jq9-JhGfbIOxAL2ZisMb-8iY"; // JWT 토큰을 입력받을 변수

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchMessages() async {
    if (jwtToken.isEmpty) {
      print("Please enter a JWT token");
      return;
    }

    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $jwtToken'; // JWT 토큰 추가

      var response = await dio.get('http://10.223.116.175:8000/history/meSummary');

      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          studyMessage = data['study']['message'];
          exerciseMessage = data['exercise']['message'];
          hobbyMessage = data['hobby']['message'];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages from FastAPI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: fetchMessages, // 버튼 클릭 시 API 호출
              child: Text('Fetch Messages'),
            ),
            SizedBox(height: 16),
            Text('Study Message:'),
            TextField(
              controller: TextEditingController(text: studyMessage),
              readOnly: true,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Exercise Message:'),
            TextField(
              controller: TextEditingController(text: exerciseMessage),
              readOnly: true,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Hobby Message:'),
            TextField(
              controller: TextEditingController(text: hobbyMessage),
              readOnly: true,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FastApiExample(),
  ));
}
