import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'services/answer_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AnswerService>(
          create: (_) => AnswerService(),
        ),
      ],
      child: MaterialApp(
        title: '答案之书',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
        routes: {
          '/favorites': (context) => Scaffold(
                appBar: AppBar(title: const Text('我的收藏')),
                body: const Center(child: Text('收藏页面 - 待实现')),
              ),
          '/history': (context) => Scaffold(
                appBar: AppBar(title: const Text('历史记录')),
                body: const Center(child: Text('历史记录页面 - 待实现')),
              ),
        },
      ),
    );
  }
}