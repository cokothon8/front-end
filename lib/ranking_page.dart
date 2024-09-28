import 'package:flutter/material.dart';
import 'ranking_list.dart'; // RankingList 컴포넌트를 import

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color _selectedColor = Colors.blue; // 선택된 탭의 색상

  bool _isEditMode = false; // 편집 모드 여부를 나타내는 변수
  Set<int> _selectedItems = {}; // 선택된 아이템의 인덱스를 저장하는 집합

  final List<Map<String, dynamic>> studyRanking = [
    {'rank': 1, 'name': 'Alice', 'xp': 14340, 'level': 45},
    {'rank': 2, 'name': 'Bob', 'xp': 10000, 'level': 98},
    {'rank': 3, 'name': 'Charlie', 'xp': 1300, 'level': 75},
    {'rank': 4, 'name': 'Alice', 'xp': 14340, 'level': 45},
    {'rank': 5, 'name': 'Bob', 'xp': 10000, 'level': 98},
    {'rank': 6, 'name': 'Charlie', 'xp': 1300, 'level': 75},
  ];

  final List<Map<String, dynamic>> exerciseRanking = [
    {'rank': 1, 'name': 'David', 'xp': 1800, 'level': 50},
    {'rank': 2, 'name': 'Eve', 'xp': 1600, 'level': 22},
    {'rank': 3, 'name': 'Frank', 'xp': 1400, 'level': 73},
  ];

  final List<Map<String, dynamic>> hobbyRanking = [
    {'rank': 1, 'name': 'Grace', 'xp': 1200, 'level': 61},
    {'rank': 2, 'name': 'Heidi', 'xp': 1100, 'level': 49},
    {'rank': 3, 'name': 'Ivan', 'xp': 1000, 'level': 37},
  ];
  final TextEditingController _nicknameController = TextEditingController();

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // 팝업 배경색
              borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 팝업의 크기를 내용에 맞게 조절
              children: [
                Text(
                  "친구 추가",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: "닉네임을 입력하세요",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 텍스트필드 둥근 모서리
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton("취소", Colors.grey, () {
                      Navigator.of(context).pop(); // 팝업 닫기
                      _nicknameController.clear(); // 텍스트필드 초기화
                    }),
                    _buildActionButton("추가", Colors.blue, () {
                      _followUser(_nicknameController.text); // 팔로우 함수 호출
                      Navigator.of(context).pop(); // 팝업 닫기
                      _nicknameController.clear(); // 텍스트필드 초기화
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _nicknameController.clear(); // 팝업이 닫힌 후 텍스트 필드 초기화
    });
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // 버튼 배경색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white), // 버튼 텍스트 색상
        ),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode; // 편집 모드 토글
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index); // 이미 선택된 경우 선택 해제
      } else {
        _selectedItems.add(index); // 선택된 경우 추가
      }
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      studyRanking.removeWhere((item) => _selectedItems.contains(studyRanking.indexOf(item)));
      _selectedItems.clear(); // 선택된 항목 초기화
      _isEditMode = false; // 편집 모드 종료
    });
  }

  void _followUser(String nickname) {
    print('Following user: $nickname');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.all(50),
            child: Text('랭킹'),
          ),
          titleTextStyle: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset(
              "assets/icon_user_add.png",
              width: 24,
              height: 24,
            ),
            onPressed: _showAddFriendDialog,
          ),
          actions: [
            IconButton(
              icon: _isEditMode ? Image.asset(
                "assets/icon_delete.png",
                width: 22,
                height: 22,
              ) : Image.asset(
                "assets/icon_pencil.png",
                width: 22,
                height: 22,
              ),
              onPressed: () {
                if (_isEditMode && _selectedItems.isNotEmpty) {
                  _deleteSelectedItems();
                } else {
                  _toggleEditMode();
                }
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight - 8.0),
            child: Container(
              height: kToolbarHeight - 20.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 3),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: '공부'),
                  Tab(text: '운동'),
                  Tab(text: '취미'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            RankingList(rankingData: studyRanking, isEditMode: _isEditMode, selectedItems: _selectedItems, onItemTap: _toggleItemSelection),
            RankingList(rankingData: exerciseRanking, isEditMode: _isEditMode, selectedItems: _selectedItems, onItemTap: _toggleItemSelection),
            RankingList(rankingData: hobbyRanking, isEditMode: _isEditMode, selectedItems: _selectedItems, onItemTap: _toggleItemSelection),
          ],
        ),
      ),
    );
  }
}
