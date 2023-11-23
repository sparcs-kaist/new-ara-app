/// 유저 설정 관리, 차단한 유저 목록, 로그아웃을 관리하는 파일.
/// Author: 김상오(alvin)

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgets/text_info.dart';
import 'package:new_ara_app/widgets/border_boxes.dart';
import 'package:new_ara_app/widgets/text_and_switch.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/models/block_model.dart';

/// 설정 페이지 빌드 및 이벤트 처리를 담당하는 StatefulWidget.
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  // 백엔드 모델과 동일한 변수명을 사용하기 위해 snake case 사용함.

  /// 성인글 보기 설정. true이면 성인글을 보여줌.
  late bool see_sexual;

  /// 정치글 보기 설정. true이면 정치글을 보여줌.
  late bool see_social;

  @override
  void initState() {
    super.initState();
    var userProvider = context.read<UserProvider>();
    see_sexual = userProvider.naUser?.see_sexual ?? true;
    see_social = userProvider.naUser?.see_social ?? true;
    // 페이지 전환 과정에서 새로운 알림을 확인하기 위한 호출.
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    var dio = Dio();
    dio.options.headers['Cookie'] = userProvider.getCookiesToString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              color: ColorsInfo.newara, width: 35, height: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          child: Text(
            'setting_page.title'.tr(),
            style: const TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 23),
                // 게시글 아이콘 및 '게시글' 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/post_list.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.bulletin'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                // 성인글 보기, 정치글 보기 스위치 버튼
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 94,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // 성인글 보기
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 성인글 보기 글씨
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "setting_page.adult".tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // 성인글 보기 CupertinoSwitch
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: see_sexual,
                                  onChanged: (value) async {
                                    setState(() => see_sexual = value);
                                    try {
                                      await dio.patch(
                                          '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                          data: {'see_sexual': value});
                                      await userProvider.apiMeUserInfo();
                                      debugPrint(
                                          "Change of 'see_sexual' succeed!");
                                    } catch (error) {
                                      debugPrint(
                                          "Change of 'see_sexual' failed: $error");
                                      setState(() => see_sexual = !value);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 정치글 보기
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 정치글 보기 글씨
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "setting_page.politics".tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // 정치글 보기 CupertinoSwitch
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: see_social,
                                  onChanged: (value) async {
                                    setState(() {
                                      see_social = value;
                                    });
                                    try {
                                      await dio.patch(
                                          '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                          data: {'see_social': value});
                                      await userProvider.apiMeUserInfo();
                                      debugPrint(
                                          "Change of 'see_social' succeed!");
                                    } catch (error) {
                                      debugPrint(
                                          "Change of 'see_social' failed: $error");
                                      setState(() => see_social = !value);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 알림 아이콘 및 '알림' 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.noti'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                // 댓글, 대댓글 설정 UI의 border 설정
                BorderBoxes(94, switchItems[1]),
                const SizedBox(height: 10),
                // 인기글 관련 설정 UI의 border 설정
                BorderBoxes(94, switchItems[2]),
                const SizedBox(height: 5),
                // 인기 공지글 제공 시간 문구
                TextInfo('setting_page.hot_info'.tr()),
                const SizedBox(height: 10),
                // 차단 아이콘, '차단' 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/barrior.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.block'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                // 차단한 유저 목록 버튼
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => BlockedUserDialog());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 13),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Center(
                            child: Text(
                              'setting_page.blocked_users'.tr(),
                              style: const TextStyle(
                                color: ColorsInfo.newara,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // 유저 차단 기능 설명 문구
                TextInfo('setting_page.block_howto'.tr()),
                const SizedBox(height: 20),
                // 로그아웃 버튼 UI (border도 포함)
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: GestureDetector(
                      onTap: () => _logout(),
                      child: const Center(
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            color: ColorsInfo.newara,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 로그아웃 관련된 모든 로직을 처리하는 함수.
  /// UserProvider, FlutterSecureStorage에서 유저 정보를 삭제함.
  Future<void> _logout() async {
    Provider.of<UserProvider>(context, listen: false).setHasData(false);
    Navigator.of(context).popUntil((route) => route.isFirst);

    // FlutterSecureStorage에서 세션 정보를 삭제함.
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.delete(key: 'cookie');
    await WebviewCookieManager().clearCookies();

    debugPrint("log out success");
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
                        BlockModel blockedUser = blockModelList[idx];
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
