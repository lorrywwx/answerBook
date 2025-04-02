import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/answer.dart';

class AnswerService extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:5000/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  
  // 获取随机答案
  Future<Answer> getRandomAnswer() async {
    try {
      final response = await _dio.get('/answers/random');
      
      if (response.statusCode == 200) {
        final data = response.data;
        // 检查是否有错误信息
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            throw Exception(data['error']);
          }
          // 检查是否包含data.answer结构
          if (data.containsKey('data') && data['data'] is Map<String, dynamic> && 
              data['data'].containsKey('answer')) {
            return Answer.fromJson(data['data']['answer']);
          }
          // 如果是直接返回answer对象结构
          return Answer.fromJson(data);
        }
        throw Exception('无效的响应数据格式：期望返回JSON对象');
      } else {
        throw Exception('服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      print('获取答案失败: $e');
      rethrow;
    }
  }
}