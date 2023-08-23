import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/public_user_profile_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

class UserViewPage extends StatefulWidget {
  final int userID;

  const UserViewPage({super.key, required this.userID});

  @override
  State<UserViewPage> createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  bool isLoaded = false;
  int nextPage = 1;
  int articleCount = 0;
  late PublicUserProfileModel userProfileModel;
  final ScrollController _listViewController = ScrollController();

  List<ArticleListActionModel> articleList = [];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    _listViewController.addListener(_listViewListener);
    context.read<NotificationProvider>().checkIsNotReadExist();
    loadAll(userProvider, 1);
  }

  void _listViewListener() async {
    // 페이지네이션 기능 수정해야함.
    if (isLoaded &&
        _listViewController.position.pixels ==
            _listViewController.position.maxScrollExtent) {
      //setIsLoaded(false);
      UserProvider userProvider = context.read<UserProvider>();
      bool userFetch = await _fetchUser(userProvider);
      bool listFetch = await _fetchCreatedArticles(userProvider, nextPage);
      if (listFetch) setIsLoaded(userFetch && listFetch);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    return !isLoaded ? const LoadingIndicator() : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              color: ColorsInfo.newara, width: 35, height: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            color: ColorsInfo.newara,
            onRefresh: () async {
              setIsLoaded(false);
              await loadAll(userProvider, 1);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48),
                            child: userProfileModel.picture == null
                                ? Container()
                                : Image.network(
                                fit: BoxFit.cover,
                                userProfileModel.picture.toString()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userProfileModel.nickname.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    '총 $articleCount개의 글',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _listViewController,
                      itemCount: articleList.length + 1,
                      itemBuilder: (BuildContext context, int idx) {
                        if (idx == articleList.length) {
                          return Visibility(
                            visible: !isLoaded,
                            child: const SizedBox(
                              height: 30,
                              child: LoadingIndicator(),
                            )
                          );
                        }
                        var curPost = articleList[idx];
                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context)
                                .push(slideRoute(PostViewPage(id: curPost.id)));
                            for (int i = 1; i <= nextPage; i++) {
                              await _fetchCreatedArticles(userProvider, i);
                            }
                            setIsLoaded(true);
                          },
                          child: SizedBox(
                            height: 61,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        curPost.title.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    curPost.attachment_type.toString() == "NONE" ? Container() : const SizedBox(width: 5),
                                    curPost.attachment_type.toString() == "BOTH"
                                        ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/image.svg',
                                          color: Colors.grey,
                                          width: 30,
                                          height: 25,
                                        ),
                                        const SizedBox(
                                          width: 9,
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/clip.svg',
                                          color: Colors.grey,
                                          width: 15,
                                          height: 20,
                                        ),
                                      ],
                                    )
                                        : curPost.attachment_type.toString() == "IMAGE"
                                        ? SvgPicture.asset(
                                      'assets/icons/image.svg',
                                      color: Colors.grey,
                                      width: 30,
                                      height: 25,
                                    )
                                        : curPost.attachment_type.toString() == "NON_IMAGE"
                                        ? SvgPicture.asset(
                                      'assets/icons/clip.svg',
                                      color: Colors.grey,
                                      width: 15,
                                      height: 20,
                                    )
                                        : Container()
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              curPost.created_by.profile.nickname
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(177, 177, 177, 1)),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            getTime(curPost.created_at.toString()),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(177, 177, 177, 1)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text('조회 ${curPost.hit_count}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(177, 177, 177, 1))),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/like.svg',
                                          width: 13,
                                          height: 15,
                                          color: ColorsInfo.newara,
                                        ),
                                        const SizedBox(width: 3),
                                        Text('${curPost.positive_vote_count}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: ColorsInfo.newara)),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/dislike.svg',
                                          width: 13,
                                          height: 15,
                                          color: const Color.fromRGBO(83, 141, 209, 1),
                                        ),
                                        const SizedBox(width: 3),
                                        Text('${curPost.negative_vote_count}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(83, 141, 209, 1))),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/comment.svg',
                                          width: 13,
                                          height: 15,
                                          color: const Color.fromRGBO(99, 99, 99, 1),
                                        ),
                                        const SizedBox(width: 3),
                                        Text('${curPost.comment_count}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(99, 99, 99, 1))),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int idx) {
                        return const Divider();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadAll(UserProvider userProvider, int page) async {
    bool userFetch = await _fetchUser(userProvider);
    bool listFetch = await _fetchCreatedArticles(userProvider, page);
    setIsLoaded(userFetch && listFetch);
  }

  void setIsLoaded(bool tf) {
    if (mounted) setState(() => isLoaded = tf);
  }

  Future<bool> _fetchUser(UserProvider userProvider) async {
    Map<String, dynamic>? userJson = await userProvider.getApiRes(
        "user_profiles/${widget.userID}"
    );
    if (userJson == null) return false;
    try {
      userProfileModel = PublicUserProfileModel.fromJson(userJson);
    } catch (error) {
      debugPrint("fetch user failed: ${widget.userID}");
      return false;
    }
    return true;
  }

  Future<bool> _fetchCreatedArticles(UserProvider userProvider, int page) async {
    int user = userProfileModel.user;
    String apiUrl = "/api/articles/?page=$page&created_by=$user";
    if (page == 1) {
      articleList.clear();
      nextPage = 1;
    }
    try {
      var response = await userProvider.myDio().get("$newAraDefaultUrl$apiUrl");
      if (response.statusCode != 200) return false;
      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost == null) {
          continue; // 가끔 형식에 맞지 않은 데이터를 가진 글이 있어 넣어놓음(2023.05.26)
        }
        try {
          articleList.add(ArticleListActionModel.fromJson(rawPost));
        } catch (error) {
          // 여기서 에러가 발생하게 된다면
          // 1. models 에 있는 모델의 타입이 올바르지 않은 경우 -> 수정하기
          // 2. models 의 타입은 올바르게 설계됨. 그러나 이전 개발 과정에서 필드 설정을 잘못한(또는 달랐던) 경우 -> 그냥 넘어가기
          debugPrint(
              "createdArticleList.add failed at index $i (id: ${rawPost['id']}) : $error");
        }
      }
      nextPage += 1;
      articleCount = response.data['num_items'];
      return true;
    } catch (error) {
      debugPrint("fetchCreatedArticles() failed with error: $error");
      return false;
    }
  }
}
