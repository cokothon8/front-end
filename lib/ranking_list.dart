import 'package:flutter/material.dart';
import 'ranking_item.dart'; // RankingItem 컴포넌트를 import

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
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFEEFC),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListView.builder(
        itemCount: rankingData.length,
        itemBuilder: (context, index) {
          final item = rankingData[index];
          final isSelected = selectedItems.contains(index);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                if (isEditMode) {
                  onItemTap(index);
                }
              },
              child: RankingItem(
                rank: item['ranking'],
                username: item['username'],
                duration: item['total_duration'],
                level: item['level'],
                isSelected: isSelected,
                isEditMode: isEditMode,
              ),
            ),
          );
        },
      ),
    );
  }
}
