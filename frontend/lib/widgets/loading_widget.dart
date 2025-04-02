import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  
  const LoadingWidget({Key? key, this.message = '加载中...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTheme.bodyStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}