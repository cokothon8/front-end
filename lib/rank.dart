import 'package:flutter/material.dart';

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
    // 여기서 닉네임을 가진 유저를 팔로우하는 로직을 추가하세요.
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
          backgroundColor: Colors.white, // AppBar 배경색 투명
          elevation: 0, // AppBar 그림자 제거
          title: Padding(
            padding: EdgeInsets.all(50), // 타이틀 좌우 여백 추가
            child: Text('랭킹'),
          ),
          titleTextStyle: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset(
              "assets/icon_user_add.png", // 친구 추가 아이콘 이미지 경로
              width: 24,
              height: 24,
            ),
            onPressed: _showAddFriendDialog,
          ),
          actions: [ IconButton(
            icon: _isEditMode ? Image.asset(
          "assets/icon_delete.png", // 친구 추가 아이콘 이미지 경로
          width: 22,
          height: 22,
        ) : Image.asset(
          "assets/icon_pencil.png", // 친구 추가 아이콘 이미지 경로
          width: 22,
          height: 22,
        ), // 아이콘을 편집 모드에 따라 변경
            onPressed: () {
              if (_isEditMode && _selectedItems.isNotEmpty) {
                _deleteSelectedItems(); // 선택된 아이템 삭제
              } else {
                _toggleEditMode(); // 편집 모드 전환
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
                      color: Colors.black.withOpacity(0.1), // 그림자 색상 및 투명도
                      offset: Offset(0, 3), // 그림자의 수평 및 수직 위치
                      blurRadius: 2.0, // 그림자 흐림 효과 (블러)
                      spreadRadius: 1.0, // 그림자 확산 반경
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab, // 인디케이터 크기 설정
                indicatorPadding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6), // 길이 및 높이 조정
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

class RankingList extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData;
  final bool isEditMode;
  final Set<int> selectedItems;
  final Function(int) onItemTap;

  RankingList({
    required this.rankingData,
    required this.isEditMode,
    required this.selectedItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0), // 랭킹 리스트의 외부 여백 설정
      padding: EdgeInsets.all(10.0), // 리스트의 외부 여백
      decoration: BoxDecoration(
        color: Color(0xFFEFEEFC), // 배경색 설정
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
      ),
      child: ListView.builder(
        itemCount: rankingData.length,
        itemBuilder: (context, index) {
          final item = rankingData[index];
          final isSelected = selectedItems.contains(index);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 각 아이템 간의 세로 간격 추가
            child: GestureDetector(
              onTap: () {
                if (isEditMode) {
                  onItemTap(index); // 편집 모드에서만 항목 선택 가능
                }
              },
              child: RankingItem(
                rank: item['rank'],
                name: item['name'],
                xp: item['xp'],
                level: item['level'],
                isSelected: isSelected, // 선택된 상태 전달
                isEditMode: isEditMode, // 편집 모드 상태 전달
              ),
            ),
          );
        },
      ),
    );
  }
}

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final int level;
  final bool isSelected;
  final bool isEditMode;
  final int maxXp = 14400;


  RankingItem({
    required this.rank,
    required this.name,
    required this.xp,
    required this.level,
    required this.isSelected,
    required this.isEditMode,
  });
  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Color(0xFFFFCE44), // 노란색
      Color(0xFF24BB74), // 초록색
      Color(0xFF004F9F), // 파란색
    ];

    int colorIndex;
    if (level >= 60) {
      colorIndex = 2; // 60 이상
    } else if (level >= 30) {
      colorIndex = 1; // 30 이상
    } else {
      colorIndex = 0; // 0 이상
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5), // 선택된 항목의 파란 그림자
            blurRadius: 10.0,
            spreadRadius: 3.0,
            offset: Offset(0, 0),
          ),
        ]
            : null, // 선택되지 않은 경우 그림자 없음
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Row 내 요소들을 수직으로 가운데 정렬
        children: [
          Container(
            height: 60.0, // 원하는 높이 설정
            child: Align(
              alignment: Alignment.center, // 중앙 정렬
              child:  rank <= 3
                  ? Image.asset(
                'assets/rank_$rank.png', // 1, 2, 3위일 때 이미지 경로 설정
                width: 40,
                height: 40,
              )
                  :Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 원 내부 배경색 설정
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFE6E6E6), // 테두리 색상 설정
                    width: 2.0, // 테두리 두께 설정
                  ),
                ),
                padding: EdgeInsets.all(4.0), // 내부 여백 추가
                child: CircleAvatar(
                  radius: 14.0, // 원의 크기 조절
                  backgroundColor: Colors.white, // 원의 배경색 하얀색
                  child: Text(
                    rank.toString(), // 4위 이상일 때 텍스트로 표시
                    style: TextStyle(
                      color: Color(0xFF858494), // 글자색을 858494로 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0), // 아이템 간의 간격
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닉네임과 레벨 표시
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Lv.$level',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // 경험치 표시
                Row(
                  children: [
                    Expanded(
                      child: Container(), // 빈 공간으로 왼쪽 여백 확보
                    ),
                    Text(
                      '${xp.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match.group(1)},')} XP',
                      style: TextStyle(fontSize: 14.0), // 경험치 텍스트 크기 설정
                      textAlign: TextAlign.right, // 텍스트를 오른쪽 정렬
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // 프로그래스바 표시
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // 프로그래스바 둥근 모서리 설정
                  child: LinearProgressIndicator(
                    value: xp / maxXp, // 현재 경험치 비율 (0.0 ~ 1.0)
                    backgroundColor: Colors.grey.shade300, // 바탕색
                    color: colors[colorIndex],
                    minHeight: 8.0, // 경험치 바의 높이
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}