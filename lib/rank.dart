import 'package:flutter/material.dart';

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color _selectedColor = Colors.blue; // 선택된 탭의 색상

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
            onPressed: () {
              // 친구 추가 버튼 클릭 시 실행할 코드
            },
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                "assets/icon_pencil.png", // 친구 추가 아이콘 이미지 경로
                width: 22,
                height: 22,
              ),
              onPressed: () {
                // 친구 추가 버튼 클릭 시 실행할 코드
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
            RankingList(rankingData: studyRanking),
            RankingList(rankingData: exerciseRanking),
            RankingList(rankingData: hobbyRanking),
          ],
        ),
      ),
    );
  }
}

class RankingList extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData;

  RankingList({required this.rankingData});

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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 항목 간 세로 간격 추가
            child: RankingItem(
              rank: item['rank'],
              name: item['name'],
              xp: item['xp'],
              level: item['level'],
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
  final int maxXp = 14400; // 최대 경험치 값

  RankingItem({
    required this.rank,
    required this.name,
    required this.xp,
    required this.level,
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
      padding: EdgeInsets.all(16.0), // 내부 여백
      decoration: BoxDecoration(
        color: Colors.white, // 아이템 배경 색상
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정

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