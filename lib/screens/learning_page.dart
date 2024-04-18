import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/theme.dart';
import 'package:juniorvoca/widgets/bottomnavbar.dart';
import 'package:juniorvoca/widgets/appbar.dart';
import 'package:juniorvoca/widgets/image_card.dart';
import 'package:juniorvoca/widgets/icon_button.dart';

class LearningPage extends StatelessWidget {
  final String userName;

  const LearningPage({
    super.key, 
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          // 상단바
          const ProgressAppbar(),
          // 메인화면
          Expanded(
            child: Container(
              width: screenWidth,
              margin: const EdgeInsets.all(45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 이미지 카드
                  const ImageCard(
                    imagePath: 'assets/images/card_pencil.png',
                  ),
                  // 단어
                  Column(
                    children: [
                      Text(
                        '연필',
                        style: AppTheme.headline1Bold.copyWith(
                          height: 0.8,
                        ),
                      ),
                      const Text(
                        'Pencil',
                        style: AppTheme.headline1Bold,
                      ),
                    ],
                  ),
                  // 예문
                  const Column(
                    children: [
                      Text(
                        '어제 연필을 하나 샀어요.',
                        style: AppTheme.body,
                      ),
                      Text(
                        'I bought one pencil yesterday.',
                        style: AppTheme.body,
                      ),
                    ],
                  ),
                  // 버튼 모음
                  const SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LargeIconButton(
                          icon: Icons.volume_down_rounded,
                        ),
                        LargeIconButton(
                          icon: Icons.keyboard_voice_rounded,
                          iconSize: 120,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // 바텀바
      bottomNavigationBar: const JuvoBottomNavBar(),
    );
  }
}
