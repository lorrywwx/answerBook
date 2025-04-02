import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();
  
  // 颜色常量
  static const Color primaryColor = Color(0xFF8C6D62);  // 棕色，书本颜色
  static const Color accentColor = Color(0xFFD4A373);   // 浅棕色，书页颜色
  static const Color backgroundColor = Color(0xFFFAEDCD); // 米色，背景颜色
  static const Color textColor = Color(0xFF3A3238);     // 深灰色，文本颜色
  static const Color secondaryTextColor = Color(0xFF6C6368); // 中灰色，次要文本颜色
  static const Color dividerColor = Color(0xFFE9DCB5);  // 浅米色，分隔线颜色
  
  // 文本样式
  static TextStyle get headingStyle => GoogleFonts.playfairDisplay(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );
  
  static TextStyle get subheadingStyle => GoogleFonts.playfairDisplay(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: textColor,
    letterSpacing: 0.3,
  );
  
  static TextStyle get bodyStyle => GoogleFonts.lora(
    fontSize: 16.0,
    color: textColor,
    letterSpacing: 0.2,
    height: 1.5,
  );
  
  static TextStyle get answerStyle => GoogleFonts.lora(
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: textColor,
    letterSpacing: 0.3,
    height: 1.6,
  );
  
  static TextStyle get buttonTextStyle => GoogleFonts.lato(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  // 主题数据
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: headingStyle.copyWith(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 24,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // 暗色主题数据
  static ThemeData get darkTheme => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: Colors.grey[900]!,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      elevation: 0,
      titleTextStyle: headingStyle.copyWith(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[800],
      thickness: 1,
      space: 24,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}