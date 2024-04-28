// PostViewPage의 글/댓글 신고, 댓글 수정에 사용되는 Dialog 위젯 파일.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';

import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/block_model.dart';
import 'package:new_ara_app/constants/url_info.dart';

/// 사용 예시
/* await showDialog(
                      context: context,
                      builder: (context) => BlockConfirmDialog(onTap: () async {}),
                    );
                    
                        */

// TODO: 현재 post_view_utils.dart와 겹침. 리팩토링 필요
/// 신고 기능이 글, 댓글 모두에게 필요하여 만든 위젯.
class ReportDialog extends StatefulWidget {
  /// 글에 대한 신고일 경우 null이 아님.
  final int? articleID;

  /// 댓글에 대한 신고일 경우 null이 아님.
  final int? commentID;
  const ReportDialog({super.key, this.articleID, this.commentID});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  /// 신고 사유 내역을 나타냄.
  List<String> reportContents = [
    "hate_speech",
    "unauthorized_sales_articles",
    "spam",
    "fake_information",
    "defamation",
    "other"
  ];

  /// 신고 사유 내역을 한국어로 나타냄.
  List<String> reportContentKor = [
    "혐오 발언",
    "허가되지 않은 판매글",
    "스팸",
    "거짓 정보",
    "명예훼손",
    "기타"
  ];

  /// 각각의 신고 내역에 대해 선택되었는지 여부를 나타냄.
  late List<bool> isChosen;

  @override
  void initState() {
    super.initState();
    isChosen = [false, false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 380,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/information.svg",
                width: 45,
                height: 45,
                colorFilter: const ColorFilter.mode(
                  ColorsInfo.newara,
                  BlendMode.srcIn,
                )),
            const SizedBox(height: 5),
            Text(
              '${widget.articleID == null ? '댓글' : '게시글'} 신고 사유를 알려주세요.',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildReportButton(0),
            const SizedBox(height: 10),
            _buildReportButton(1),
            const SizedBox(height: 10),
            _buildReportButton(2),
            const SizedBox(height: 10),
            _buildReportButton(3),
            const SizedBox(height: 10),
            _buildReportButton(4),
            const SizedBox(height: 10),
            _buildReportButton(5),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상을 빨간색으로 지정
                        width: 1, // 테두리의 두께를 2로 지정
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    postReport().then((res) {
                      debugPrint("신고가 ${res ? '성공' : '실패'}하였습니다.");
                      if (res) Navigator.pop(context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara.withOpacity((isChosen[0] ||
                              isChosen[1] ||
                              isChosen[2] ||
                              isChosen[3] ||
                              isChosen[4] ||
                              isChosen[5])
                          ? 1
                          : 0.5),
                    ),
                    width: 100,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '신고하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 신고 내역을 API 요청을 통해 서버에 보내는 역할.
  Future<bool> postReport() async {
    if (!isChosen[0] &&
        !isChosen[1] &&
        !isChosen[2] &&
        !isChosen[3] &&
        !isChosen[4] &&
        !isChosen[5]) {
      // 나중에 알림 해주기
      return false;
    }
    String reportContent = "";
    for (int i = 0; i < 6; i++) {
      if (!isChosen[i]) continue;
      if (reportContent != "") reportContent += ", ";
      reportContent += reportContents[i];
    }
    debugPrint("reportContent: $reportContent");
    Map<String, dynamic> defaultPayload = {
      "content": reportContent,
      "type": "others",
    };
    defaultPayload.addAll(widget.articleID == null
        ? {"parent_comment": widget.commentID ?? 0}
        : {"parent_article": widget.articleID ?? 0});
    UserProvider userProvider = context.read<UserProvider>();
    Response? postRes =
        await userProvider.postApiRes('reports/', data: defaultPayload);
    if (postRes == null) {
      debugPrint("postReport() failed with error");
      return false;
    }

    return true;
  }

  // 각각의 신고항목에 대한 button
  InkWell _buildReportButton(int idx) {
    return InkWell(
      onTap: () {
        if (!mounted) return;
        setState(() => isChosen[idx] = !isChosen[idx]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isChosen[idx]
              ? ColorsInfo.newara
              : const Color.fromRGBO(220, 220, 220, 1),
        ),
        width: 180,
        height: 40,
        child: Center(
          child: Text(
            reportContentKor[idx],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isChosen[idx] ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

/// PostViewPage의 댓글 삭제 기능에 사용되는 Dialog
class DeleteDialog extends StatelessWidget {
  final UserProvider userProvider;

  /// PostViewPage의 context.
  final BuildContext targetContext;

  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  const DeleteDialog({
    super.key,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 350,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/information.svg',
              width: 55,
              height: 55,
              colorFilter: const ColorFilter.mode(
                ColorsInfo.newara,
                BlendMode.srcIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                LocaleKeys.dialogs_deleteConfirm.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // PostViewPage에서 pop해야 하므로
                    // targetContext 사용.
                    Navigator.pop(targetContext);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_cancel.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  // 인자로 전달받은 onTap 사용.
                  onTap: onTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_confirm.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BlockedUserDialog extends StatefulWidget {
  const BlockedUserDialog({super.key});
  @override
  State<BlockedUserDialog> createState() => _BlockedUserDialogState();
}

class _BlockedUserDialogState extends State<BlockedUserDialog> {
  /// 차단된 유저의 BlockModel을 저장하는 리스트
  late List<BlockModel> blockModelList;

  /// blockModelList의 초기화가 완료되었으면 true, 아니면 false
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchBlockedUsers().then((resList) {
      blockModelList = resList;
      if (mounted) {
        setState(() => isLoaded = true);
      }
    });
  }

  /// 차단된 유저 목록을 fetch한 후 BlockModel의 리스트로 변환.
  /// 성공 시에 BlockModel의 리스트를 반환함. 실패할 시 empty list 반환.
  Future<List<BlockModel>> fetchBlockedUsers() async {
    UserProvider userProvider = context.read<UserProvider>();
    String apiUrl = "/api/blocks/";
    List<BlockModel> resList = [];
    try {
      var response = await userProvider
          .createDioWithHeadersForGet()
          .get("$newAraDefaultUrl$apiUrl");
      List<dynamic> jsonUserList = response.data['results'];
      for (Map<String, dynamic> json in jsonUserList) {
        try {
          resList.add(BlockModel.fromJson(json));
        } catch (error) {
          debugPrint(
              "Model structure of BlockModel might have changed: $error");
        }
      }
      return resList;
    } on DioException catch (e) {
      debugPrint("DioException occurred");
      if (e.response != null) {
        debugPrint("${e.response!.data}");
        debugPrint("${e.response!.headers}");
        debugPrint("${e.response!.requestOptions}");
      }
      // request의 setting, sending에서 문제 발생
      // requestOption, message를 출력.
      else {
        debugPrint("${e.requestOptions}");
        debugPrint("${e.message}");
      }
    } catch (e) {
      debugPrint("fetchBlockedUsers GET error: $e");
    }
    return resList;
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? Container()
        : Dialog(
            child: blockModelList.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 55,
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_noBlockedUsers.tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 55.0 * blockModelList.length,
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: ListView.separated(
                      itemCount: blockModelList.length,
                      itemBuilder: (context, idx) {
                        // 변경을 방지하기 위해 final 선언함.
                        final BlockModel blockedUser = blockModelList[idx];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          child: Row(
                            children: [
                              // 사용자 프로필 이미지 표시
                              // 이미지 링크가 null일 경우 warning 아이콘 표시
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(20),
                                    child: Image.network(
                                      blockedUser.user.profile.picture ??
                                          "null",
                                      fit: BoxFit.cover,
                                      //이미지를 네트워크에서 불러올 동안 보여줄 위젯이 필요함.
                                      //https://stackoverflow.com/questions/73047825/add-placeholder-to-a-network-image-in-flutter
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container();
                                      },
                                      // 정상적인 이미지 로드에 실패했을 경우
                                      // warning 아이콘 표시하기
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        debugPrint("$error");
                                        return SizedBox(
                                          child: SvgPicture.asset(
                                            "assets/icons/warning.svg",
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                            width: 35,
                                            height: 35,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  blockedUser.user.profile.nickname ??
                                      LocaleKeys.dialogs_noNickname.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  bool unblockRes =
                                      await unblockUser(blockedUser.id);
                                  // 차단해제 요청이 성공하면 blockModelList에서 유저를 제거함.
                                  // 차단 해제 중 새로운 차단된 유저가 추가되는 경우가 거의 없다고 판단함.
                                  // 따라서 차단 유저 목록 refetch는 진행하지 않고 blockedUser만 제거함.
                                  if (unblockRes) {
                                    setState(() {
                                      blockModelList.remove(blockedUser);
                                    });
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/close-2.svg",
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) {
                        return const Divider();
                      },
                    ),
                  ),
          );
  }

  /// 유저 차단을 취소하는 API요청을 보냄.
  /// 성공하면 true. 아니면 false 반환.
  Future<bool> unblockUser(int userID) async {
    UserProvider userProvider = context.read<UserProvider>();
    String apiUrl = "/api/blocks/$userID/";
    try {
      await userProvider
          .createDioWithHeadersForNonget()
          .delete("$newAraDefaultUrl$apiUrl");
      return true;
    } on DioException catch (e) {
      debugPrint("DioException occurred");
      if (e.response != null) {
        debugPrint("${e.response!.data}");
        debugPrint("${e.response!.headers}");
        debugPrint("${e.response!.requestOptions}");
      }
      // request의 setting, sending에서 문제 발생
      // requestOption, message를 출력.
      else {
        debugPrint("${e.requestOptions}");
        debugPrint("${e.message}");
      }
    } catch (e) {
      debugPrint("unblock error: $e");
    }
    return false;
  }
}

/// PostViewPage의 댓글 삭제 기능에 사용되는 Dialog
class BlockConfirmDialog extends StatelessWidget {
  final UserProvider userProvider;

  /// PostViewPage의 context.
  final BuildContext targetContext;

  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  const BlockConfirmDialog({
    super.key,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 350,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/information.svg',
              width: 55,
              height: 55,
              colorFilter: const ColorFilter.mode(
                ColorsInfo.newara,
                BlendMode.srcIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                LocaleKeys.dialogs_blockConfirm.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // PostViewPage에서 pop해야 하므로
                    // targetContext 사용.
                    Navigator.pop(targetContext);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_cancel.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  // 인자로 전달받은 onTap 사용.
                  onTap: onTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_confirm.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignoutConfirmDialog extends StatelessWidget {
  final UserProvider userProvider;

  /// PostViewPage의 context.
  final BuildContext targetContext;

  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  const SignoutConfirmDialog({
    super.key,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 350,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/information.svg',
              width: 55,
              height: 55,
              colorFilter: const ColorFilter.mode(
                ColorsInfo.newara,
                BlendMode.srcIn,
              ),
            ),
            Text(
              LocaleKeys.dialogs_logoutConfirm.tr(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // PostViewPage에서 pop해야 하므로
                    // targetContext 사용.
                    Navigator.pop(targetContext);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_cancel.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  // 인자로 전달받은 onTap 사용.
                  onTap: onTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_confirm.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UnregisterConfirmDialog extends StatelessWidget {
  final UserProvider userProvider;

  /// PostViewPage의 context.
  final BuildContext targetContext;

  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  const UnregisterConfirmDialog({
    super.key,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 360,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/information.svg',
              width: 55,
              height: 55,
              colorFilter: const ColorFilter.mode(
                ColorsInfo.newara,
                BlendMode.srcIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                LocaleKeys.dialogs_withdrawalConfirm.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                LocaleKeys.dialogs_withdrawalEmailInfo.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFBBBBBB),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // PostViewPage에서 pop해야 하므로
                    // targetContext 사용.
                    Navigator.pop(targetContext);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_cancel.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  // 인자로 전달받은 onTap 사용.
                  onTap: onTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara,
                    ),
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        LocaleKeys.dialogs_confirm.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForAndroidTesterDialog extends StatelessWidget {
  final UserProvider userProvider;
  final _scrollController = ScrollController();

  /// PostViewPage의 context.
  final BuildContext targetContext;

  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  ForAndroidTesterDialog({
    super.key,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: SizedBox(
          width: 350,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/information.svg',
                width: 55,
                height: 55,
                colorFilter: const ColorFilter.mode(
                  ColorsInfo.newara,
                  BlendMode.srcIn,
                ),
              ),
              const Text(
                'Dear Google Play Review Team,',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    10,
                    20,
                    10,
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ListView(
                        controller: _scrollController,
                        children: const [
                          Text(
                            '''I am writing to seek assistance regarding an issue we have encountered following the production review of our app on the Google Play Store.

During our production review process, we observed an unusual volume of comments within our app, which appear to be related to the review process itself. These abnormal comments were made using an account provided exclusively to Google Play Store reviewers. This situation has caused significant inconvenience, especially for students who rely on our app for communication and educational purposes.

While we understand the importance of thorough app reviews and user feedback, we suspect that a misunderstanding or a technical issue has led to the excessive commenting. This not only affects the app's performance but also its acceptance among our target audience.

To resolve this issue, we would greatly appreciate it if you could provide guidelines on why comment posting is necessary during the review process and what features we should demonstrate. Our goal is to ensure a positive and constructive environment for our users while adhering to Google Play's policies and standards.

We are thankful for your understanding and support on this matter. Please let us know if there are specific procedures we should follow or if additional information is required from our side.

Thank you for your attention and support on this issue. We look forward to your prompt response.

Sincerely,


안녕하십니까? 구글 플레이 스토어의 프로덕션 심사 후 저희가 마주한 문제에 대해 도움을 요청하기 위해 이 메시지를 작성합니다.

저희 프로덕션 심사 과정 중, 앱 내에서 심사 과정과 관련된 것으로 보이는 비정상적인 댓글 양을 관찰했습니다. 이 비정상적인 댓글은 구글 플레이 스토어 심사관에게만 제공한 계정을 통해 작성되었습니다. 이는 특히 저희 앱을 소통과 교육 목적으로 의존하는 학생들의 사용자 경험에 큰 불편을 초래하고 있습니다.

철저한 앱 리뷰와 사용자 피드백의 중요성을 이해하고 있지만, 과도한 댓글이 발생한 배경에는 오해나 기술적 문제가 있을 것으로 생각합니다. 이는 앱의 성능뿐만 아니라 저희 타겟 오디언스 사이에서의 수용성에도 영향을 미치고 있습니다.

이 문제를 해결하기 위해, 심사 과정 중 앱 내에서 댓글 작성이 필요한 이유와 저희가 어떤 기능을 보여줘야 하는지에 대한 가이드라인을 제시해주시면 감사하겠습니다. 저희의 목표는 구글 플레이의 정책과 기준을 준수하면서 사용자에게 긍정적이고 건설적인 환경을 보장하는 것입니다.

이 문제에 대한 이해와 지원에 감사드립니다. 저희가 따라야 할 특정한 절차가 있거나 저희 측에서 추가 정보가 필요한 경우 알려주시기 바랍니다.

이 문제에 주목해주시고 지원해주셔서 감사합니다. 신속한 답변과 지원을 기대합니다.

감사합니다,  

Google Playストアでのアプリのプロダクションレビュー後に遭遇した問題について支援を求めています。

プロダクションレビュープロセス中に、レビュープロセス自体に関連していると思われるアプリ内での異常なコメントの量を観察しました。これらの異常なコメントは、Google Playストアのレビュアーにのみ提供されたアカウントを使用して作成されました。この状況は、通信および教育目的で私たちのアプリに依存している学生を含むユーザーにとって、大きな不便を引き起こしています。

徹底的なアプリレビューとユーザーフィードバックの重要性を理解していますが、過剰なコメントにつながった誤解または技術的な問題があると疑っています。これは、アプリのパフォーマンスだけでなく、ターゲットオーディエンスの間での受け入れにも影響を与えています。

この問題を解決するために、レビュープロセス中にコメント投稿が必要な理由と、私たちが示すべき機能についてのガイドラインを提供していただければ幸いです。私たちの目標は、Google Playのポリシーと基準を遵守しながら、ユーザーにとって肯定的で建設的な環境を確保することです。

この件に関するご理解とサポートに感謝します。特定の手順を踏むべきか、私たちの側から追加情報が必要かどうか教えてください。

この問題に対するご注意とサポートに感謝します。迅速なご返答をお待ちしています。

敬具、
                            ''',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    // 인자로 전달받은 onTap 사용.
                    onTap: onTap,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: ColorsInfo.newara,
                      ),
                      width: 80,
                      height: 40,
                      child: const Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
