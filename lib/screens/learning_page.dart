import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juniorvoca/styles/colors.dart';
import 'package:juniorvoca/styles/theme.dart';
import 'package:juniorvoca/widgets/appbar.dart';
import 'package:juniorvoca/widgets/bottomnavbar.dart';
import 'package:juniorvoca/widgets/icon_button.dart';
import 'package:juniorvoca/widgets/image_card.dart';
import 'package:juniorvoca/utils/chatgpt_service.dart';
import 'package:juniorvoca/utils/simple_recorder.dart';

class VocaItem {
  final String image;
  final String word;
  final String meaning;
  String originalSentence;
  String translatedSentence;
  
  VocaItem({
    required this.image,
    required this.word,
    required this.meaning,
    this.originalSentence = '',
    this.translatedSentence = '',
  });

  // Json 데이터를 VocaItem 객체로 변환
  factory VocaItem.fromJson(Map<String, dynamic> json) {
    return VocaItem(
      image: json['image'],
      word: json['word'],
      meaning: json['meaning'],
    );
  }
}

class LearningPage extends StatefulWidget {
  final String userName;

  const LearningPage({
    super.key,
    required this.userName,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List<VocaItem> vocaItems = [];
  int _currentIndex = 0;
  bool _dataLoaded = false;
  final PageController _pageController = PageController();
  final simpleRecorder = SimpleRecorder();
  String transcription = "";

  @override
  void initState() {
    super.initState();
    loadData();
    simpleRecorder.init();
    simpleRecorder.setTranscriptionCallback((String result) {
      setState(() {
        transcription = result;
      });
    });
  }

  // 데이터 로드 후 VocaItem 객체로 변환
  Future<void> loadData() async {
    String jsonString = await rootBundle.loadString('assets/words/day1.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;
    vocaItems = jsonData.map((item) => VocaItem.fromJson(item as Map<String, dynamic>)).toList();

    final chatGptService = ChatGPTService();
    
    // 각 VocaItem 객체에 대해 ChatGPT 활용 문장을 생성 및 처리
    for (var vocaItem in vocaItems) {
      String fullSentence = await chatGptService.generateSentence(vocaItem.meaning);
      List<String> sentences = fullSentence.split('\n');
      if (sentences.length == 2) {
        vocaItem.originalSentence = sentences[0].trim();
        vocaItem.translatedSentence = sentences[1].trim();
      } else {
        vocaItem.originalSentence = fullSentence.trim();
        vocaItem.translatedSentence = "";
      }
    }

    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (!_dataLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          // 상단바
          ProgressAppbar(
            currentIndex:_currentIndex,
            totalCount: vocaItems.length,
          ),
          // 메인화면
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: vocaItems.length,
              itemBuilder: (context, index) {
                return Container(
                  width: screenWidth,
                  margin: const EdgeInsets.all(45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 이미지 카드
                      ImageCard(
                        imagePath: vocaItems[index].image,
                      ),
                      // 단어
                      Column(
                        children: [
                          Text(
                            vocaItems[index].meaning,
                            style: AppTheme.headline1Bold.copyWith(
                              height: 0.8,
                            ),
                          ),
                          Text(
                            transcription.isNotEmpty
                                ? transcription
                                : '____',
                            style: AppTheme.headline1Bold.copyWith(
                              color: AppColors.colorPrimaryDefault,
                            ),
                          ),
                        ],
                      ),
                      // 예문
                      Column(
                        children: [
                          Text(
                            vocaItems[index].originalSentence.isNotEmpty
                                ? vocaItems[index].originalSentence
                                : 'Loading sentence...',
                            style: AppTheme.body,
                          ),
                          Text(
                            vocaItems[index].translatedSentence.isNotEmpty
                                ? vocaItems[index].translatedSentence
                                : 'Loading sentence...',
                            style: AppTheme.body,
                          ),
                        ],
                      ),
                      // 버튼 모음
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 스피커 버튼
                            LargeIconButton(
                              icon: Icons.volume_down_rounded,
                              onPressed: () =>
                                  (simpleRecorder.getPlaybackFn() ?? () {})(),
                            ),
                            // 마이크 버튼
                            LargeIconButton(
                              icon: Icons.keyboard_voice_rounded,
                              iconSize: 120,
                              onPressed: () =>
                                  (simpleRecorder.getRecorderFn() ?? () {})(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
      // 바텀바
      bottomNavigationBar: const JuvoBottomNavBar(),
    );
  }
}
