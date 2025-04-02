import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/answer.dart';
import '../services/answer_service.dart';
import '../theme/app_theme.dart';
import '../widgets/advanced_book_widget.dart';
import '../widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pageAnimation;
  bool _isFlipping = false;
  bool _isLoading = false;
  Answer? _currentAnswer;
  
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // 创建翻页动画
    _pageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // 监听动画状态
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadRandomAnswer();
      _isFirstLoad = false;
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // 加载随机答案
  Future<void> _loadRandomAnswer() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final answerService = Provider.of<AnswerService>(context, listen: false);
      final answer = await answerService.getRandomAnswer();
      
      // 重置翻页状态
      setState(() {
        _isFlipping = false;
        _currentAnswer = answer;
        _isLoading = false;
      });

      // 重置动画控制器
      _animationController.reset();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFlipping = false;
      });
      
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取答案失败: ${e.toString()}'))
      );
    }
  }
  
  // 翻页获取新答案
  void _flipPageForNewAnswer() {
    if (_isFlipping || _isLoading) return;
    
    setState(() {
      _isFlipping = true;
    });
    
    // 开始翻页动画
    _animationController.forward(from: 0.0).then((_) {
      // 动画完成后加载新答案
      _loadRandomAnswer();
    });
  }
  
  // 收藏当前答案
  void _favoriteCurrentAnswer() {
    if (_currentAnswer == null) return;
    
    // TODO: 实现收藏功能
    // 1. 调用后端API保存收藏
    // 2. 更新UI状态
    // 3. 显示成功提示
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('收藏功能即将上线'))
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('答案之书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // 导航到收藏页面
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // 导航到历史记录页面
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const LoadingWidget(message: '正在翻阅答案之书...')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 高级书本组件
                  AdvancedBookWidget(
                    answer: _currentAnswer,
                    pageAnimation: _pageAnimation,
                    isFlipping: _isFlipping,
                    onFavoritePressed: _currentAnswer != null
                        ? () => _favoriteCurrentAnswer()
                        : null,
                  ),
                  const SizedBox(height: 40),
                  // 翻页按钮
                  ElevatedButton(
                    onPressed: _flipPageForNewAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      '翻阅答案之书1111',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}