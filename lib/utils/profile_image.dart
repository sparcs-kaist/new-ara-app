import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// profileUri에 있는 이미지를 주어진 width, height로 빌드함.
/// 이미지 로드에 실패한 경우 assets/icons/warning.svg를 리턴.
/// PostViewPage, UserPage, UserViewPage, ProfileEditPage에서 사용.
/// 위 페이지 모두 공통된 형식으로 사용하여 함수로 리팩토링함.
/// ```
/// Container(
///   width: 30,
///   height: 30,
///   decoration: const BoxDecoration(
///     shape: BoxShape.circle,
///     color: Colors.grey,
///   ),
///   child: ClipRRect(
///     borderRadius: const BorderRadius.all(Radius.circular(100)),
///     child: SizedBox.fromSize(
///       size: const Size.fromRadius(15),
///       child: buildProfileImage(profileUri, width, height),
///     ),
///   ),
/// );
/// ```
Widget buildProfileImage(String? profileUri, double width, double height) {
  // Image.network의 errorBuilder가 작동하였음에도 exception이 발생하는 경우 발견
  // 또한 null인 이미지는 호출 후 error를 처리하기보다 미리 감지하는 것이 낫다고 판단하여
  // 아래 삼항연산자 조건문을 적용함.
  return profileUri == null
      ? SizedBox(
          child: SvgPicture.asset(
            "assets/icons/warning.svg",
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
            width: width,
            height: height,
          ),
        )
      : Image.network(
          fit: BoxFit.cover,
          profileUri.toString(),
          // 정상적인 이미지 로드에 실패했을 경우
          // warning 아이콘 표시하기
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            debugPrint("PostViewPage creator: $error");
            return SizedBox(
              child: SvgPicture.asset(
                "assets/icons/warning.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                width: width,
                height: height,
              ),
            );
          },
        );
}
