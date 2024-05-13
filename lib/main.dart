import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Junior Voca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(userName: '홍길동'), // 사용자 이름을 전달
    );
  }
}

class HomePage extends StatelessWidget {
  final String userName; // 사용자 이름을 저장

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Junior Voca'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, $userName 님!', // 사용자 이름을 출력
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            StudyItem(
              label: 'A 영어 학습',
              initialValue: 0.7,
              page: GeneralStudyPage(), // 일반 학습 페이지 연결
            ),
            SizedBox(height: 20),
            StudyItem(
              label: '가 한국어 학습',
              initialValue: 0.5,
              page: ParentVoiceStudyPage(), // 부모 목소리 학습 페이지 연결
            ),
            SizedBox(height: 20),
            StudyItem(
              label: 'A가 영어+한국어 동시 학습',
              initialValue: 0.8,
              page: WordExampleStudyPage(), // 단어와 예문 학습 페이지 연결
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildStudyArea(context, '일반 학습', GeneralStudyPage()), // 일반 학습 페이지 연결
                  _buildStudyArea(context, '부모 목소리 학습', ParentVoiceStudyPage()), // 부모 목소리 학습 페이지 연결
                  _buildStudyArea(context, '단어와 예문 학습', WordExampleStudyPage()), // 단어와 예문 학습 페이지 연결
                  _buildStudyArea(context, '음성인식 AI 테스트', VoiceRecognitionTestPage()), // 음성인식 AI 테스트 페이지 연결
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
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '언어 추가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  Widget _buildStudyArea(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class StudyItem extends StatefulWidget {
  final String label;
  final double initialValue;
  final Widget page;

  StudyItem({Key? key, required this.label, required this.initialValue, required this.page})
      : super(key: key);

  @override
  _StudyItemState createState() => _StudyItemState();
}

class _StudyItemState extends State<StudyItem> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialValue;
  }

  void updateProgress(double newValue) {
    setState(() {
      _progress = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              Align(
                alignment: Alignment(_progress * 2 - 1, -1), // 게이지 바 끝 부분에 말풍선 정렬
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      '${(_progress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                // 학습 이어하기 기능을 추가
              },
              child: Text(
                '학습 이어하기',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralStudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일반 학습'),
      ),
      body: Center(
        child: Text('일반 학습 페이지'),
      ),
    );
  }
}

class ParentVoiceStudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('부모 목소리 학습'),
      ),
      body: Center(
        child: Text('부모 목소리 학습 페이지'),
      ),
    );
  }
}

class WordExampleStudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('단어와 예문 학습'),
      ),
      body: Center(
        child: Text('단어와 예문 학습 페이지'),
      ),
    );
  }
}

class VoiceRecognitionTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음성인식 AI 테스트'),
      ),
      body: Center(
        child: Text('음성인식 AI 테스트 페이지'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Center(
        child: Text('설정 페이지'),
      ),
    );
  }
}
