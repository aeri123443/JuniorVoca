import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';
import 'package:juniorvoca/styles/theme.dart';
import 'package:juniorvoca/widgets/progress_indicator.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Junior Voca'),
      backgroundColor: AppColors.backgroundPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // 설정 버튼을 누르면 설정 화면으로 이동하는 기능을 추가.
          },
        ),
      ],
    );
  }
}

class ProgressAppbar extends StatelessWidget{
  final int currentIndex;
  final int totalCount;

  const ProgressAppbar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    
    double value = ( currentIndex + 1 ) / totalCount;
    final double screenTop = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      height: 110.0,
      // 상태바 높이만큼 위쪽 여백 추가
      padding: EdgeInsets.only(top: screenTop), 
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            color: AppColors.textPrimary,
            icon: const Icon(Icons.arrow_back_ios_new_sharp), 
            onPressed: (){
              // 메인으로 이동
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 학습하기 텍스트
                const Text(
                  '학습하기',
                  style: AppTheme.titleMedium,  
                ),
                const SizedBox(height: 10,),
                // 진행바
                CustomProgressIndicator(
                  value: value,
                  currentIndex: currentIndex,
                  totalCount: totalCount,
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}
