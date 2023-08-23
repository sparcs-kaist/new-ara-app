import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/models/notification_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final ScrollController _listViewController;
  bool _isLoadingTotal = true, _isLoadingNewPage = false;
  int _curPage = 1;
  List<NotificationModel> _modelList = [];

  @override
  void initState() {
    super.initState();
    _listViewController = ScrollController()
      ..addListener(_listViewListener);
    UserProvider userProvider = context.read<UserProvider>();
    _initNotificationPage(userProvider);
  }

  Future<void> _initNotificationPage(UserProvider userProvider) async {
    _modelList = await _fetchEachPage(userProvider, 1);
    _curPage = 1;
    _setIsLoadingTotal(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<NotificationModel>> _fetchEachPage(UserProvider userProvider, int targetPage) async {
    var dio = Dio()
        ..options.headers["Cookie"] = userProvider.getCookiesToString();
    List<NotificationModel> resList = [];
    try {
      var response = await dio.get(
        "$newAraDefaultUrl/api/notifications/?page=$targetPage"
      );
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

  void _listViewListener() async {
    if (_isLoadingNewPage) return;
    if (_listViewController.position.pixels == _listViewController.position.maxScrollExtent) {
      _setIsLoadingNewPage(true);
      bool hasNext = true;
      UserProvider userProvider = context.read<UserProvider>();
      List<NotificationModel> resList = [];
      var dio = Dio()
        ..options.headers["Cookie"] = userProvider.getCookiesToString();
      int page = 1;
      for (page = 1; hasNext; page++) {
        if (page > _curPage + 1) break;
        try {
          var response = await dio.get(
            "$newAraDefaultUrl/api/notifications/?page=$page"
          );
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

  void update() {
    if (mounted) setState(() {});
  }

  void _setIsLoadingTotal(bool value) {
    if (mounted) setState(() => _isLoadingTotal = value);
  }

  void _setIsLoadingNewPage(bool value) {
    if (mounted) setState(() => _isLoadingNewPage = value);
  }

  Future<bool> _readNotification(UserProvider userProvider, int id) async {
    try {
      await userProvider.myDio().post(
        "$newAraDefaultUrl/api/notifications/$id/read/"
      );
    } catch (error) {
      debugPrint("POST /api/notifications/$id/read/ failed: $error");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'appBar.notification'.tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.white,
            splashColor: Colors.white,
            icon: SvgPicture.asset(
              'assets/icons/search.svg', color: ColorsInfo.newara,
              width: 45,
              height: 45,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
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
                  child: RefreshIndicator(
                    color: ColorsInfo.newara,
                    onRefresh: () async {
                      await _initNotificationPage(userProvider);
                      update();
                    },
                    child: _isLoadingTotal ? const LoadingIndicator()
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
                        return Column(
                          children: [
                            idx != 0 ? _buildDateInfo(_modelList[idx - 1].created_at,
                                _modelList[idx].created_at) : const SizedBox(
                              height: 40,
                              child: Text(
                                '오늘',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(177, 177, 177, 1),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    slideRoute(PostViewPage(
                                      id: targetNoti.related_article.id,
                                    ))
                                  );
                                  if (mounted) {
                                    setState(() => targetNoti.is_read = true);
                                  }
                                  bool res = await _readNotification(userProvider, targetNoti.id);
                                  if (!res && mounted) {
                                    setState(() => targetNoti.is_read = false);
                                  }
                                  List<NotificationModel> newList = [];
                                  for (int page = 1; page <= _curPage; page++) {
                                    newList += await _fetchEachPage(userProvider, page);
                                  }
                                  if (mounted) {
                                    setState(() => _modelList = newList);
                                  }
                                },
                                child: Container(
                                  height: 90,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(230, 230, 230, 1),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (targetNoti.is_read ?? false) ? Colors.grey
                                              : ColorsInfo.newara,
                                        ),
                                        child: SvgPicture.asset(
                                          targetNoti.type == "default" ? "assets/icons/notification.svg"
                                              : "assets/icons/comment.svg",
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              targetNoti.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: (targetNoti.is_read ?? false) ? Colors.grey
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              targetNoti.content,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "| 게시글: ${targetNoti.related_article.title}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
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
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String strDate1, String strDate2) {
    DateTime now = DateTime.now();
    DateTime prevDate = DateTime.parse(strDate1).toLocal();
    DateTime curDate = DateTime.parse(strDate2).toLocal();
    if (prevDate.year == curDate.year && prevDate.month == curDate.month &&
        prevDate.day == curDate.day) return Container();
    String dateText = "${(curDate.year != now.year ? "${curDate.year}년 " : "")}${curDate.month}월 ${curDate.day}일";
    return SizedBox(
      height: 60,
      child: Center(
        child: Text(
          dateText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(177, 177, 177, 1),
          ),
        ),
      ),
    );
  }
}
