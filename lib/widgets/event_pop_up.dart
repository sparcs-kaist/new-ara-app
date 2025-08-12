// 이벤트 진행시 안내를 위하 팝업니다. 메인 페이지 진입시 (아마도 앱 최초 실행시에 등장하며,
//  사용되는 포스터 이미지, 이벤트 기간등을 설정해 매 이벤트 마다 재활용 가능하도록 하였습니다.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/pages/post_view_page.dart';

class EventPopup extends StatelessWidget {
  final String imageAssetPath;
  final VoidCallback? onImageTap; // 이미지 탭 시 동작

  const EventPopup({
    super.key,
    required this.imageAssetPath,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                // 이미지 전체 클릭 가능
                behavior: HitTestBehavior.opaque,
                onTap: onImageTap,
                child: Image.asset(
                  imageAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black45, // 가독성을 위한 반투명 배경
                    ),
                    padding: const EdgeInsets.all(6),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 이벤트 세부 옵션 변경 (이미지, 기간) 을 위해서는 아래를 수정하세요.

/// 한국시간(KST) 기준으로 8/12 00:00 ~ 8/17 23:59:59 사이에만 표시.
/// dev/prod 각각 다른 게시글로 redirect 가능 (ID) 필요
Future<void> showEventPopupIfNeeded(
  BuildContext context, {
  int? articleIdDev = 12385,
  int? articleIdProd = 260057,
  String imagePath = 'assets/images/event_250813.png',
  bool? forceIsProd, // 테스트용 강제 스위치 (선택)
}) async {
  final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
  final int year = nowKst.year;
  final start = DateTime(year, 8, 13, 0, 0, 0); // KST
  final end = DateTime(year, 8, 17, 23, 59, 59); // KST
  if (nowKst.isBefore(start) || nowKst.isAfter(end)) return;

  // APP_ENV=prod | dev 로 빌드 시 지정 가능. 미지정이면 kReleaseMode를 사용.
  const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  final isProd = forceIsProd ?? (appEnv == 'prod' || kReleaseMode);
  final targetArticleId = isProd ? articleIdProd : articleIdDev;

  await showDialog(
    context: context,
    barrierDismissible: true, // 배경 탭으로 닫힘
    builder: (dialogCtx) => EventPopup(
      imageAssetPath: imagePath,
      onImageTap: (targetArticleId == null)
          ? null
          : () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(dialogCtx).push(
                MaterialPageRoute(
                  builder: (_) => PostViewPage(id: targetArticleId),
                ),
              );
            },
    ),
  );
}
