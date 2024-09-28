import 'package:flutter/material.dart';

class RankingItem extends StatelessWidget {
  final int rank;
  final String username;
  final int duration;
  final int level;
  final bool isSelected;
  final bool isEditMode;
  final int maxXp = 14400;

  RankingItem({
    required this.rank,
    required this.username,
    required this.duration,
    required this.level,
    required this.isSelected,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Color(0xFFFFCE44),
      Color(0xFF24BB74),
      Color(0xFF004F9F),
    ];

    int colorIndex;
    if (level >= 60) {
      colorIndex = 2;
    } else if (level >= 30) {
      colorIndex = 1;
    } else {
      colorIndex = 0;
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 10.0,
            spreadRadius: 3.0,
            offset: Offset(0, 0),
          ),
        ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            child: Align(
              alignment: Alignment.center,
              child:  rank <= 3
                  ? Image.asset(
                'assets/rank_$rank.png',
                width: 40,
                height: 40,
              )
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFE6E6E6),
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      color: Color(0xFF858494),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
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
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      '${duration.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match.group(1)},')} XP',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: LinearProgressIndicator(
                    value: duration / maxXp,
                    backgroundColor: Colors.grey.shade300,
                    color: colors[colorIndex],
                    minHeight: 8.0,
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
