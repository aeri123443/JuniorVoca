import 'package:flutter/material.dart';
// import 'package:juniorvoca/screens/home_page.dart';
import 'package:juniorvoca/styles/colors.dart';
import 'package:juniorvoca/screens/learning_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Junior Voca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
      ),
      home: const LearningPage(userName: '홍길동'), // 사용자 이름을 전달
    );
  }
}
