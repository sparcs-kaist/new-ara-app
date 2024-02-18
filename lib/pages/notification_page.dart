/// 사용자에 대한 이때까지의 알림을 보여주는 페이지 관리 파일
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/models/notification_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

/// 알림페이지의 빌드 및 이벤트 처리를 담당하는 위젯.
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  /// 알림 ListView를 제어하는 컨트롤러
  late final ScrollController _listViewController;

  /// 알림 리스트 자체를 새로고침 중인지 나타내는 변수.
  bool _isLoadingTotal = true;

  /// 사용자의 스크롤에 따라 다음 페이지의 알림을 불러오는 중인지 나타내는 변수.
  bool _isLoadingNewPage = false;

  /// 현재까지 불러온 가장 마지막 알림 페이지를 나타냄.
  int _curPage = 1;

  /// 알림 ListView에 표시되는 알림 모델의 리스트.
  List<NotificationModel> _modelList = [];

  @override
  void initState() {
    super.initState();
    _listViewController = ScrollController()..addListener(_listViewListener);
    UserProvider userProvider = context.read<UserProvider>();
    _initNotificationPage(userProvider);
  }

  /// 사용자가 페이지에 처음 진입할 때, 화면 새로고침 시에 사용됨.
  /// API 통신을 위해 [userProvider]를 전달받음.
  Future<void> _initNotificationPage(UserProvider userProvider) async {
    _modelList = await _fetchEachPage(userProvider, 1);
    _curPage = 1;
    _setIsLoadingTotal(false);
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  /// [targetPage]를 통해 지정한 페이지의 알림을 불러와 모델로 변환 후,
  /// 결과 리스트를 반환함.
  Future<List<NotificationModel>> _fetchEachPage(
      UserProvider userProvider, int targetPage) async {
    Dio dio = userProvider.createDioWithHeadersForGet();
    List<NotificationModel> resList = [];
    try {
      var response = await dio
          .get("$newAraDefaultUrl/api/notifications/?page=$targetPage");
      List<dynamic> resultsList = response.data["results"];
      for (var json in resultsList) {
        try {
          resList.add(NotificationModel.fromJson(json));
        } catch (error) {
          debugPrint("$error");
          continue;
        }
      }
    } catch (error) {
      return [];
    }
    return resList;
  }

  /// 알림 ListView를 구독 중인 리스너이며
  /// 사용자가 ListView의 끝에 도달하였을 때 이를 감지하여
  /// 새로운 페이지를 로딩함.
  // TODO: Future<void>로 변경 (Resolved)
  // TODO: 마지막 페이지에 도달했을 때 스크롤 안되게 하기
  Future<void> _listViewListener() async {
    if (_isLoadingNewPage) return;
    if (_listViewController.position.pixels >=
        _listViewController.position.maxScrollExtent) {
      _setIsLoadingNewPage(true);
      bool hasNext = true;
      UserProvider userProvider = context.read<UserProvider>();
      List<NotificationModel> resList = [];
      Dio dio = userProvider.createDioWithHeadersForGet();
      int page = 1;
      for (page = 1; hasNext; page++) {
        if (page > _curPage + 1) break;
        try {
          var response =
              await dio.get("$newAraDefaultUrl/api/notifications/?page=$page");
          hasNext = response.data["next"] == null ? false : true;
          List<dynamic> resultsList = response.data["results"];
          for (var json in resultsList) {
            try {
              resList.add(NotificationModel.fromJson(json));
            } catch (error) {
              debugPrint("$error");
              continue;
            }
          }
        } catch (error) {
          debugPrint("$error");
          return;
        }
      }
      _curPage = page;
      _modelList = resList;
      _setIsLoadingNewPage(false);
    }
  }

  // TODO: 메서드명을 updateState로 변경 (Resolved)
  void updateState() {
    if (mounted) setState(() {});
  }

  void _setIsLoadingTotal(bool value) {
    if (mounted) setState(() => _isLoadingTotal = value);
  }

  void _setIsLoadingNewPage(bool value) {
    if (mounted) setState(() => _isLoadingNewPage = value);
  }

  /// id에 해당하는 알림을 읽음 처리해주는 함수.
  /// API 통신에 필요한 [userProvider], 알림 식별에 필요한 [id]를 전달받음.
  /// 읽음 처리가 성공하면 true, 그렇지 않으면 false 리턴.
  Future<bool> _readNotification(UserProvider userProvider, int id) async {
    try {
      await userProvider
          .createDioWithHeadersForNonget()
          .post("$newAraDefaultUrl/api/notifications/$id/read/");
    } catch (error) {
      debugPrint("POST /api/notifications/$id/read/ failed: $error");
      return false;
    }
    return true;
  }

  /// 알림 모두 읽기 기능에 사용됨.
  /// API 통신을 위해 [userProvider]를 이용함.
  /// 모두 읽음 처리 성공 시에 true, 아니면 false를 반환함.
  Future<bool> _readAllNotification(UserProvider userProvider) async {
    try {
      await userProvider
          .createDioWithHeadersForNonget()
          .post("$newAraDefaultUrl/api/notifications/read_all/");
    } catch (error) {
      debugPrint("POST /api/notifications/read_all failed: $error");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    NotificationProvider notificationProvider =
        context.read<NotificationProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'appBar.notification'.tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  // Android, IOS에 따라 당겨서 새로고침 디자인이 다르므로
                  // adaptive 적용.
                  child: RefreshIndicator.adaptive(
                    color: ColorsInfo.newara,
                    onRefresh: () async {
                      // 새로고침 시 첫 페이지만 다시 불러옴.
                      await _initNotificationPage(userProvider);
                      await notificationProvider.checkIsNotReadExist(userProvider);
                      updateState();
                    },
                    child: _isLoadingTotal
                        ? const LoadingIndicator()
                        : ListView.separated(
                            controller: _listViewController,
                            itemCount: _modelList.length + 1,
                            itemBuilder: (context, idx) {
                              if (idx == _modelList.length) {
                                return Visibility(
                                  visible: _isLoadingNewPage,
                                  child: const SizedBox(
                                    height: 45,
                                    child: LoadingIndicator(),
                                  ),
                                );
                              }
                              NotificationModel targetNoti = _modelList[idx];
                              // 개별 알림을 리턴함.
                              return Column(
                                children: [
                                  idx != 0
                                      ? _buildDateInfo(
                                          _modelList[idx - 1].created_at,
                                          _modelList[idx].created_at)
                                      : const SizedBox(
                                          height: 35,
                                          child: Text(
                                            '오늘',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  177, 177, 177, 1),
                                            ),
                                          ),
                                        ),
                                  InkWell(
                                      onTap: () async {
                                        // 알림 클릭 시에 해당하는 글로 이동.
                                        await Navigator.of(context)
                                            .push(slideRoute(PostViewPage(
                                          id: targetNoti.related_article.id,
                                        )));
                                        if (mounted) {
                                          setState(
                                              () => targetNoti.is_read = true);
                                        }
                                        bool res = await _readNotification(
                                            userProvider, targetNoti.id);
                                        if (!res && mounted) {
                                          setState(
                                              () => targetNoti.is_read = false);
                                        }
                                        await notificationProvider
                                            .checkIsNotReadExist(userProvider);
                                        List<NotificationModel> newList = [];
                                        for (int page = 1;
                                            page <= _curPage;
                                            page++) {
                                          newList += await _fetchEachPage(
                                              userProvider, page);
                                        }
                                        if (mounted) {
                                          setState(() => _modelList = newList);
                                        }
                                      },
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(minHeight: 92),
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 14,
                                            bottom: 14),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xfff0f0f0),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x0A000000),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(height: 5),
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        (targetNoti.is_read ??
                                                                false)
                                                            ? Color(0xffbbbbbb)
                                                            : ColorsInfo.newara,
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      width: 30,
                                                      height: 28,
                                                      targetNoti.type ==
                                                              "default"
                                                          ? "assets/icons/notification.svg"
                                                          : "assets/icons/comment.svg",
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              Colors.white,
                                                              BlendMode.srcIn),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    targetNoti.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          (targetNoti.is_read ??
                                                                  false)
                                                              ? Colors.grey
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    targetNoti.content,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "| 게시글: ${targetNoti.related_article.title}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              );
                            },
                            separatorBuilder: (context, idx) {
                              return const SizedBox(height: 10);
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 모두 읽음 처리를 위한 버튼.
      // TODO: 디자이너와 모두 읽기 기능 위치, 위젯 조정해야함
      floatingActionButton: FloatingActionButton(
        // TODO: 산재되어있는 return 하나로 통일하기 (Resolved)
        onPressed: () async {
          if (notificationProvider.isNotReadExist) {
            _setIsLoadingTotal(true);
            bool res = await _readAllNotification(userProvider);
            if (res) {
              // TODO: checkIsNotReadExist 호출하지 않고 처리 (resolved)
              notificationProvider.setIsNotReadExist(false);
              List<NotificationModel> newList = [];
              for (int page = 1; page <= _curPage; page++) {
                newList += await _fetchEachPage(userProvider, page);
              }
              _modelList = newList;
              _setIsLoadingTotal(false);
            } else {
              debugPrint("모두 읽기 요청 실패");
              _setIsLoadingTotal(false);
            }
          }
        },
        backgroundColor: Colors.white,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/verified.svg',
            fit: BoxFit.cover,
            color: ColorsInfo.newara,
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }

  /// 현재 date와 알림 생성 date의 차이를 계산하여 문자열로 변경해줌.
  Widget _buildDateInfo(String strDate1, String strDate2) {
    DateTime now = DateTime.now();
    DateTime prevDate = DateTime.parse(strDate1).toLocal();
    DateTime curDate = DateTime.parse(strDate2).toLocal();
    if (prevDate.year == curDate.year &&
        prevDate.month == curDate.month &&
        prevDate.day == curDate.day) return Container();
    String dateText =
        "${(curDate.year != now.year ? "${curDate.year}년 " : "")}${curDate.month}월 ${curDate.day}일";
    return SizedBox(
      height: 60,
      child: Center(
        child: Text(
          dateText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xffbbbbbb),
          ),
        ),
      ),
    );
  }
}
