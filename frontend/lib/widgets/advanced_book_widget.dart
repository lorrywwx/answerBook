import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/answer.dart';
import '../theme/app_theme.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AdvancedBookWidget extends StatefulWidget {
  final Answer? answer;
  final Animation<double> pageAnimation;
  final bool isFlipping;
  final VoidCallback? onFavoritePressed;

  const AdvancedBookWidget({
    Key? key,
    required this.answer,
    required this.pageAnimation,
    required this.isFlipping,
    this.onFavoritePressed,
  }) : super(key: key);

  @override
  State<AdvancedBookWidget> createState() => _AdvancedBookWidgetState();
}

class _AdvancedBookWidgetState extends State<AdvancedBookWidget> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // 书本阴影
          _buildBookShadow(),
          
          // 书本封面
          _buildBookCover(),
          
          // 书页内容
          AnimatedBuilder(
            animation: widget.pageAnimation,
            builder: (context, child) {
              // 当动画值为0.5以上时，显示内页
              final showPage = widget.pageAnimation.value > 0.5;
              
              return showPage
                  ? _buildBookPage()
                  : const SizedBox.shrink();
            },
          ),
          
          // 翻页动画
          AnimatedBuilder(
            animation: widget.pageAnimation,
            builder: (context, child) {
              return _buildFlippingPage();
            },
          ),
        ],
      ),
    );
  }

  // 构建书本阴影
  Widget _buildBookShadow() {
    return Positioned(
      bottom: 10,
      left: 15,
      right: 15,
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  // 构建书本封面
  Widget _buildBookCover() {
    return Container(
      width: 320,
      height: 430,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/book_cover_texture.png'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Stack(
        children: [
          // 书脊装饰
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: Colors.brown.shade800.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(1, 0),
                  ),
                ],
              ),
            ),
          ),
          
          // 书本标题
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  '答案之书',
                  style: AppTheme.headingStyle.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '寻找你的答案',
                  style: AppTheme.subheadingStyle.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          // 书本装饰边框
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.brown.shade800.withOpacity(0.8),
                width: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建书页
  Widget _buildBookPage() {
    return Container(
      width: 320,
      height: 430,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade800, width: 1),
        image: const DecorationImage(
          image: AssetImage('assets/images/paper_texture.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Stack(
        children: [
          // 页面内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 36,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 30),
                widget.answer != null
                    ? AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            widget.answer!.content,
                            textStyle: AppTheme.answerStyle,
                            textAlign: TextAlign.center,
                            speed: const Duration(milliseconds: 50),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                      )
                    : Text(
                        '翻阅答案之书，寻找你的答案...',
                        style: AppTheme.answerStyle,
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(height: 30),
                if (widget.answer?.categoryName != null)
                  Text(
                    '—— ${widget.answer!.categoryName}',
                    style: AppTheme.bodyStyle.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
              ],
            ),
          ),
          
          // 收藏按钮
          if (widget.answer != null)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : AppTheme.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  if (widget.onFavoritePressed != null) {
                    widget.onFavoritePressed!();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  // 构建翻页动画
  Widget _buildFlippingPage() {
    // 如果不在翻页状态，则不显示翻页动画
    if (!widget.isFlipping) {
      return const SizedBox.shrink();
    }
    
    // 计算翻页角度
    final angle = widget.pageAnimation.value * math.pi;
    
    // 计算阴影透明度 - 在翻页过程中增加阴影效果
    final shadowOpacity = 0.3 + (0.3 * math.sin(angle));
    
    return Positioned(
      right: 0,
      child: Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002) // 增强透视效果
          ..rotateY(angle),
        child: Container(
          width: 320,
          height: 430,
          decoration: BoxDecoration(
            color: angle < math.pi / 2
                ? AppTheme.primaryColor
                : AppTheme.accentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.brown.shade800,
              width: angle < math.pi / 2 ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity),
                blurRadius: 10,
                offset: Offset(angle < math.pi / 2 ? -5 : 5, 5),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(
                angle < math.pi / 2
                    ? 'assets/images/book_cover_texture.png'
                    : 'assets/images/paper_texture.png',
              ),
              fit: BoxFit.cover,
              opacity: angle < math.pi / 2 ? 0.2 : 0.1,
            ),
          ),
          child: angle < math.pi / 2
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_stories,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '答案之书',
                        style: AppTheme.headingStyle.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Opacity(
                  opacity: (angle - math.pi / 2) / (math.pi / 2),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                '正在寻找你的答案...',
                                textStyle: AppTheme.answerStyle,
                                textAlign: TextAlign.center,
                                speed: const Duration(milliseconds: 80),
                              ),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}