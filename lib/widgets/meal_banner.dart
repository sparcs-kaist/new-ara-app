import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_ara_app/providers/theme_provider.dart';

class MealBanner extends StatelessWidget {
  final VoidCallback onTap;

  const MealBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // 부드러운 그라디언트로 변경
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF2C3E50), // 차분한 다크 블루그레이
                    const Color(0xFF34495E),
                  ]
                : [
                    const Color(0xFFF8F9FA), // 밝은 그레이 배경
                    const Color(0xFFFFFFFF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          // 테두리 추가로 구분감
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 왼쪽 아이콘 영역 - 포인트 컬러 적용
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFFE31B23).withOpacity(0.15)
                    : const Color(0xFFFFEBEE), // 연한 빨강
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_menu,
                  color: const Color(0xFFE31B23), // 포인트 컬러
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 학식',
                    style: TextStyle(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF212121),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '오늘의 메뉴를 확인해보세요',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF757575),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // 오른쪽 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.4)
                  : const Color(0xFFBDBDBD),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
