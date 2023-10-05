/// 임의의 유저에 대한 닉네임, 프로필, 작성한 글 등을 보여주는 페이지 관리 파일.
/// article, comment에서 작성자의 정보를 확인하는 기능을 위해 만들어짐.

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

/// 유저 관련 정보 페이지 뷰, 이벤트 처리를 모두 관리하는 StatefulWidget
class UserViewPage extends StatefulWidget {
  final int userID;

  const UserViewPage({super.key, required this.userID});

  @override
  State<UserViewPage> createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  /// 페이지 로딩이 완료되었는지 여부를 나타냄.
  bool _isLoaded = false;

  /// 작성한 글 호출에 사용.
  /// 다음에 불러와야 하는 글 페이지를 나타냄.
  int _nextPage = 1;

  /// 작성한 글의 전체 개수.
  /// 페이지에 표시되는 글의 개수와 무관함.
  int _articleCount = 0;

  late PublicUserProfileModel _userProfileModel;
  final ScrollController _listViewController = ScrollController();

  /// 사용자가 작성한 글 모델을 저장하는 리스트.
  List<ArticleListActionModel> _articleList = [];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    _listViewController.addListener(_listViewListener);

    // 페이지 로드 시 새로운 알림이 있는 지 조회.
    context.read<NotificationProvider>().checkIsNotReadExist();
    loadAll(userProvider, 1);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    return !_isLoaded ? const LoadingIndicator() : Scaffold(
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
                // 사용자 프로필 이미지, 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: Row(
                    children: [
                      // 사용자 프로필 이미지
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
                            child: _userProfileModel.picture == null
                                ? Container()
                                : Image.network(
                                fit: BoxFit.cover,
                                _userProfileModel.picture.toString()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 사용자 닉네임 텍스트
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _userProfileModel.nickname.toString(),
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
                // 총 N개의 글
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    '총 $_articleCount개의 글',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // 작성한 글 목록 표시
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListView.separated(
                      // PullToRefresh를 위해 아래 physics 추가 필요
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _listViewController,
                      itemCount: _articleList.length + 1,
                      itemBuilder: (BuildContext context, int idx) {
                        // 스크롤의 최하단에 왔을 때 로딩 인디케이터가 보이도록 설정
                        if (idx == _articleList.length) {
                          return Visibility(
                            visible: !_isLoaded,
                            child: const SizedBox(
                              height: 30,
                              child: LoadingIndicator(),
                            )
                          );
                        }
                        var curPost = _articleList[idx];
                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context)
                                .push(slideRoute(PostViewPage(id: curPost.id)));
                            for (int i = 1; i <= _nextPage; i++) {
                              await _fetchCreatedArticles(userProvider, i);
                            }
                            setIsLoaded(true);
                          },
                          // 각각의 작성한 글
                          child: SizedBox(
                            height: 61,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 글 제목 및 첨부파일 이미지 표시
                                Row(
                                  children: [
                                    // 글 제목 텍스트
                                    Flexible(
                                      child: Text(
                                        curPost.title.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // 첨부파일 이미지
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
                                // 사용자 닉네임부터 댓글 개수까지 표시하는 Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 닉네임, 작성한 날짜, 조회수 표시 Row
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
                                    // 좋아요, 싫어요, 댓글 표시 Row
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

  /// 유저 정보, 작성한 글 모두를 fetch함.
  /// API 통신을 위해 userProvider, 작성한 글 페이지 지정을 위해 page를 parameter로 받음.
  /// 유저 정보, 작성한 글 fetch 후에 별도의 리턴값없이 state를 업데이트함.
  Future<void> loadAll(UserProvider userProvider, int page) async {
    bool userFetch = await _fetchUser(userProvider);
    bool listFetch = await _fetchCreatedArticles(userProvider, page);
    setIsLoaded(userFetch && listFetch);
  }

  /// isLoaded 변수의 값을 설정. 설정된 값에 따라 state를 변경해주는 함수.
  /// API 통신 및 fetch 작업 이후 state 업데이트가 자주 시행됨에 따라 함수로 작성함.
  void setIsLoaded(bool tf) {
    if (mounted) setState(() => _isLoaded = tf);
  }

  /// 유저 정보를 조회하여 멤버 변수 userProfileModel을 설정하는 함수.
  /// API 통신을 위해 userProvider 변수를 전달받음.
  /// API 통신 및 userProfileModel에 정보 저장이 모두 성공적일 경우 true.
  /// 아닌 경우 false 반환.
  Future<bool> _fetchUser(UserProvider userProvider) async {
    Map<String, dynamic>? userJson = await userProvider.getApiRes(
        "user_profiles/${widget.userID}"
    );
    if (userJson == null) return false;
    try {
      _userProfileModel = PublicUserProfileModel.fromJson(userJson);
    } catch (error) {
      debugPrint("fetch user failed: ${widget.userID}");
      return false;
    }
    return true;
  }

  /// 작성한 글 리스트를 불러와 멤버 변수 articleList에 저장하는 함수.
  /// API 통신을 위해 userProvider, _fetchCreatedArticles 호출을 위해 page를 전달받음
  /// API 통신 및 작성한 글 리스트 저장이 모두 성공할 경우 true. 아니면 false 반환.
  Future<bool> _fetchCreatedArticles(UserProvider userProvider, int page) async {
    int user = _userProfileModel.user;
    String apiUrl = "/api/articles/?page=$page&created_by=$user";
    // 첫 페이지일 경우 기존에 존재하는 article을 모두 제거.
    if (page == 1) {
      _articleList.clear();
      _nextPage = 1;
    }
    try {
      var response = await userProvider.myDio().get("$newAraDefaultUrl$apiUrl");
      if (response.statusCode != 200) return false;
      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost == null) {
          continue; // 가끔 형식에 맞지 않은 데이터를 가진 글이 있어 추가함.(2023.05.26)
        }
        try {
          _articleList.add(ArticleListActionModel.fromJson(rawPost));
        } catch (error) {
          // 여기서 에러가 발생하게 된다면
          // 1. models 에 있는 모델의 타입이 올바르지 않은 경우 -> 수정하기
          // 2. models 의 타입은 올바르게 설계됨. 그러나 이전 개발 과정에서 필드 설정을 잘못한(또는 달랐던) 경우 -> 그냥 넘어가기
          debugPrint(
              "createdArticleList.add failed at index $i (id: ${rawPost['id']}) : $error");
        }
      }
      _nextPage += 1;
      _articleCount = response.data['num_items'];
      return true;
    } catch (error) {
      debugPrint("fetchCreatedArticles() failed with error: $error");
      return false;
    }
  }

  /// 작성한 글 리스트뷰를 listen함.
  /// 스크롤의 끝에 도달하였는지 확인 및 새로운 페이지 호출에 사용됨.
  void _listViewListener() async {
    // 페이지네이션 기능 수정해야함.(2023.09.21)
    if (_isLoaded &&
        _listViewController.position.pixels ==
            _listViewController.position.maxScrollExtent) {
      //setIsLoaded(false);
      UserProvider userProvider = context.read<UserProvider>();
      bool userFetch = await _fetchUser(userProvider);
      bool listFetch = await _fetchCreatedArticles(userProvider, _nextPage);
      if (listFetch) setIsLoaded(userFetch && listFetch);
    }
  }
}
