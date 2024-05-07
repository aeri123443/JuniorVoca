import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';
import 'package:juniorvoca/styles/theme.dart';

class MainProgressIndicator extends StatelessWidget{
  final String label;
  final double value;

  const MainProgressIndicator({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.body,
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.shadowColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.colorPrimaryDefault),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                // 학습 이어하기 기능을 추가
              },
              child: const Text(
                '학습 이어하기 >',
                style: AppTheme.caption
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomProgressIndicator extends StatelessWidget{

  final double value;
  final int currentIndex;
  final int totalCount;

  const CustomProgressIndicator({
    super.key,
    required this.value,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(30, 2, 30, 2),
          child: LinearProgressIndicator(
            value: value,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: AppColors.shadowColor,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.colorPrimaryDefault),
          ),
        ),
        Text(
          '${currentIndex+1}/$totalCount',
          style: AppTheme.caption,  
        ),
      ],
    );
  }
}
