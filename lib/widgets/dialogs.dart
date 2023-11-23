/// PostViewPage의 글/댓글 신고, 댓글 수정에 사용되는 Dialog 위젯 파일.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/block_model.dart';
import 'package:new_ara_app/constants/url_info.dart';

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
            SvgPicture.asset(
              "assets/icons/information.svg",
              width: 45,
              height: 45,
              color: ColorsInfo.newara,
            ),
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
    try {
      await userProvider.postApiRes(
        "reports/",
        payload: defaultPayload,
      );
    } catch (error) {
      debugPrint("postReport() failed with error: $error");
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
              color: ColorsInfo.newara,
            ),
            const Text(
              '정말로 삭제하시겠습니까?',
              style: TextStyle(
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
                    child: const Center(
                      child: Text(
                        '확인',
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
      var response = await userProvider.myDio().get("$newAraDefaultUrl$apiUrl");
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
                    child: const Center(
                      child: Text(
                      "차단한 유저가 없습니다",
                      style: TextStyle(
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
                              // 사용자 프로필 이미지 표시(null이 아닌 경우)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: blockedUser.user.profile.picture == null
                                    ? Container()
                                    : ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(40),
                                          child: Image.network(
                                              fit: BoxFit.cover,
                                              blockedUser
                                                  .user.profile.picture!),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  blockedUser.user.profile.nickname ??
                                      "닉네임이 없음",
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
      await userProvider.myDio().delete("$newAraDefaultUrl$apiUrl");
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