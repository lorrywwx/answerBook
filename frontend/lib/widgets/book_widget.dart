import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/answer.dart';
import '../theme/app_theme.dart';

class BookWidget extends StatelessWidget {
  final Answer? answer;
  final Animation<double> pageAnimation;
  final bool isFlipping;

  const BookWidget({
    Key? key,
    required this.answer,
    required this.pageAnimation,
    required this.isFlipping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 书本封面
          Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown.shade800, width: 2),
            ),
            child: Center(
              child: Text(
                '答案之书',
                style: AppTheme.headingStyle.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // 书页内容
          AnimatedBuilder(
            animation: pageAnimation,
            builder: (context, child) {
              // 当动画值为0时，显示封面；当动画值为1时，显示内页
              final showPage = pageAnimation.value > 0.5;
              
              return showPage
                  ? _buildBookPage()
                  : const SizedBox.shrink();
            },
          ),
          
          // 翻页动画
          AnimatedBuilder(
            animation: pageAnimation,
            builder: (context, child) {
              return _buildFlippingPage();
            },
          ),
        ],
      ),
    );
  }

  // 构建书页
  Widget _buildBookPage() {
    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown.shade800, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              answer?.content ?? '翻阅答案之书，寻找你的答案...',
              style: AppTheme.answerStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (answer?.categoryName != null)
              Text(
                '—— ${answer!.categoryName}',
                style: AppTheme.bodyStyle.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.secondaryTextColor,
                ),
                textAlign: TextAlign.right,
              ),
          ],
        ),
      ),
    );
  }

  // 构建翻页动画
  Widget _buildFlippingPage() {
    // 如果不在翻页状态，则不显示翻页动画
    if (!isFlipping) {
      return const SizedBox.shrink();
    }
    
    // 计算翻页角度
    final angle = pageAnimation.value * math.pi;
    
    return Positioned(
      right: 0,
      child: Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // 添加透视效果
          ..rotateY(angle),
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: angle < math.pi / 2
                ? AppTheme.primaryColor
                : AppTheme.accentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.brown.shade800,
              width: angle < math.pi / 2 ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: angle < math.pi / 2
              ? Center(
                  child: Text(
                    '答案之书',
                    style: AppTheme.headingStyle.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 2,
                    ),
                  ),
                )
              : Opacity(
                  opacity: (angle - math.pi / 2) / (math.pi / 2),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        '正在寻找你的答案...',
                        style: AppTheme.answerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}