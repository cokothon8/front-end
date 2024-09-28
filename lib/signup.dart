import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '회원가입 페이지',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Dio dio = Dio();

  String _registrationMessage = '';

  Future<void> register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      Response response = await dio.post(
        'http://10.223.116.175:8000/users/signup', // 회원가입 API URL
        options: Options(
          headers: {'Content-Type': 'application/json'}, // Content-Type을 JSON으로 변경
        ),
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        String accessToken = response.data['access_token'];
        String tokenType = response.data['token_type'];
        String refreshToken = response.data['refresh_token'];
        setState(() {
          _registrationMessage =
          '회원가입 성공!\nAccess Token: $accessToken\nToken Type: $tokenType\nRefresh Token: $refreshToken';
        });
      } else if (response.statusCode == 409) {
        setState(() {
          _registrationMessage = '이미 사용 중인 사용자 이름입니다.';
        });
      } else {
        setState(() {
          _registrationMessage =
          '회원가입 실패: 상태 코드 ${response.statusCode}, 메시지: ${response.statusMessage}';
        });
      }
    } on DioError catch (e) {
      setState(() {
        String errorDetails = e.response?.data?.toString() ?? '알 수 없는 오류';
        _registrationMessage = '회원가입 실패! 오류: ${e.response?.statusCode ?? '알 수 없음'} - ${e.message}\n상세 오류: $errorDetails';
      });
      print('DioError: ${e.response?.data}');
    } catch (e) {
      setState(() {
        _registrationMessage = '회원가입 실패! 예기치 못한 오류 발생: $e';
      });
      print('Unexpected Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('회원가입 페이지')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              Text(
                _registrationMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
