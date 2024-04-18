import 'package:flutter/material.dart';
import 'package:juniorvoca/widgets/appbar.dart';
import 'package:juniorvoca/widgets/bottomnavbar.dart';
import 'package:juniorvoca/widgets/study_area.dart';
import 'package:juniorvoca/widgets/progress_indicator.dart';
import 'package:juniorvoca/styles/theme.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({
    super.key, 
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, $userName 님!', // 사용자 이름을 출력
              style: AppTheme.headlineBold,
            ),
            const SizedBox(height: 20),
            const MainProgressIndicator(label:'A 영어 학습', value: 0.7),
            const SizedBox(height: 20),
            const MainProgressIndicator(label: '가 한국어 학습', value:0.5),
            const SizedBox(height: 20),
            const MainProgressIndicator(label: 'A가 영어+한국어 동시 학습', value: 0.8),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: const [
                  BuildStudyArea(title: '일반 학습'),
                  BuildStudyArea(title: '부모 목소리 학습'),
                  BuildStudyArea(title: '단어와 예문 학습'),
                  BuildStudyArea(title: '음성인식 AI 테스트'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 단어 추가 버튼을 누르면 단어 추가 화면으로 이동하는 기능을 추가
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const JuvoBottomNavBar(),
    );
  }
}
