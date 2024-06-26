// 임의의 유저에 대한 닉네임, 프로필, 작성한 글 등을 보여주는 페이지 관리 파일.
// article, comment에서 작성자의 정보를 확인하는 기능을 위해 만들어짐.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/public_user_profile_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/utils/profile_image.dart';
import 'package:new_ara_app/widgets/post_preview.dart';

/// 유저 관련 정보 페이지 뷰, 이벤트 처리를 모두 관리하는 StatefulWidget
/// **중요: name_type == 1 이 아닌 경우에 대해서는 사용하면 안됨.**
class UserViewPage extends StatefulWidget {
  /// 정보 조회의 대상이되는 user의 ID.
  final int userID;

  const UserViewPage({super.key, required this.userID});

  @override
  State<UserViewPage> createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  /// 페이지 로딩이 완료되었는지 여부를 나타냄.
  bool _isLoaded = false;

  /// 스크롤 최하단에 도달하여 다음 페이지를 로딩중일 경우 true.
  /// 아니면 false.
  bool _isLoadingNewPage = false;

  /// 작성한 글 호출에 사용.
  /// 다음에 불러와야 하는 글 페이지를 나타냄.
  int _nextPage = 1;

  /// 작성한 글의 전체 개수.
  /// 페이지에 표시되는 글의 개수와 무관함.
  int _articleCount = 0;

  /// 유저 정보를 저장하는 모델
  late PublicUserProfileModel _userProfileModel;

  final ScrollController _listViewController = ScrollController();

  /// 사용자가 작성한 글 모델을 저장하는 리스트.
  final List<ArticleListActionModel> _articleList = [];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    _listViewController.addListener(_listViewListener);

    // 페이지 로드 시 새로운 알림이 있는 지 조회.
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
    loadAll(userProvider, 1);
  }

  /// 작성한 글 리스트뷰를 listen함.
  /// 스크롤의 끝에 도달하였는지 확인 및 새로운 페이지 호출에 사용됨.
  void _listViewListener() async {
    // 이미 다음 페이지를 호출하는 경우는 제외
    if (!_isLoadingNewPage) {
      // 사용자가 최대로 스크롤한 경우
      // TODO: 마지막 페이지에 도달했을 때 스크롤 안되게 하기
      if (_isLoaded &&
          _listViewController.position.pixels >=
              _listViewController.position.maxScrollExtent) {
        _setIsLoadingNewPage(true);
        UserProvider userProvider = context.read<UserProvider>();
        bool userFetch = await _fetchUser(userProvider);
        bool listFetch = await _fetchCreatedArticles(userProvider, _nextPage);
        if (listFetch) _setIsLoaded(userFetch && listFetch);
        _setIsLoadingNewPage(false);
      }
    }
  }

  /// _isLoadingNewPage의 값을 매개변수 tf로 변경 후 state를 업데이트함.
  /// UserViewPage에서 스크롤을 통해 새로운 페이지를 로드할 때 사용.
  void _setIsLoadingNewPage(bool tf) {
    if (mounted) setState(() => _isLoadingNewPage = tf);
  }

  /// 유저 정보, 작성한 글 모두를 fetch함.
  /// API 통신을 위해 userProvider, 작성한 글 페이지 지정을 위해 page를 parameter로 받음.
  /// 유저 정보, 작성한 글 fetch 후에 별도의 리턴값없이 state를 업데이트함.
  Future<void> loadAll(UserProvider userProvider, int page) async {
    bool userFetch = await _fetchUser(userProvider);
    bool listFetch = await _fetchCreatedArticles(userProvider, page);
    _setIsLoaded(userFetch && listFetch);
  }

  /// isLoaded 변수의 값을 설정. 설정된 값에 따라 state를 변경해주는 함수.
  /// API 통신 및 fetch 작업 이후 state 업데이트가 자주 시행됨에 따라 함수로 작성함.
  /// UserViewPage 전체의 내용을 로드할 때 사용.
  void _setIsLoaded(bool tf) {
    if (mounted) setState(() => _isLoaded = tf);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              colorFilter:
                  const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
              width: 35,
              height: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: !_isLoaded
            ? const LoadingIndicator()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator.adaptive(
                  color: ColorsInfo.newara,
                  onRefresh: () async {
                    _setIsLoaded(false);
                    await loadAll(userProvider, 1);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 사용자 프로필 이미지, 텍스트
                      _buildUserInfo(),
                      const Divider(),
                      // 총 N개의 글
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(
                          context.locale == const Locale('ko')
                              ? '총 $_articleCount개의 글'
                              : '$_articleCount posts',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(177, 177, 177, 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // 작성한 글 목록 표시
                      _buildArticleList(userProvider),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /// 사용자 프로필 이미지, 닉네임을 빌드.
  /// 빌드된 위젯을 리턴.
  Widget _buildUserInfo() {
    return SizedBox(
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
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(25),
                // 이미지 링크를 확인한 후 null인 이미지는 warning.svg를 빌드
                child: buildProfileImage(_userProfileModel.picture, 45, 45),
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
    );
  }

  Widget _buildArticleList(UserProvider userProvider) {
    return Expanded(
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
                  visible: _isLoadingNewPage,
                  child: const SizedBox(
                    height: 40,
                    child: LoadingIndicator(),
                  ));
            }
            var curPost = _articleList[idx];
            return InkWell(
              onTap: () async {
                await Navigator.of(context)
                    .push(slideRoute(PostViewPage(id: curPost.id)));
                // 사용자가 글을 보고 돌아왔을 때 리스트를 업데이트.
                for (int i = 1; i <= _nextPage; i++) {
                  await _fetchCreatedArticles(userProvider, i);
                }
                _setIsLoaded(true);
              },
              // 각각의 작성한 글
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                  child: PostPreview(model: curPost)),
            );
          },
          separatorBuilder: (BuildContext context, int idx) {
            return Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            );
          },
        ),
      ),
    );
  }

  /// 글에 첨부된 파일의 타입에 따른 위젯을 리턴하는 함수.
  // ignore: unused_element
  Widget _buildAttachImage(String attachmentType) {
    return Row(
      children: [
        if (attachmentType == "NONE") Container() else const SizedBox(width: 5),
        if (attachmentType == "BOTH")
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/image.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
                width: 30,
                height: 25,
              ),
              const SizedBox(
                width: 5,
              ),
              SvgPicture.asset(
                'assets/icons/clip.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
                width: 15,
                height: 20,
              ),
            ],
          )
        else if (attachmentType == "IMAGE")
          SvgPicture.asset(
            'assets/icons/image.svg',
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ),
            width: 30,
            height: 25,
          )
        else if (attachmentType == "NON_IMAGE")
          SvgPicture.asset(
            'assets/icons/clip.svg',
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ),
            width: 15,
            height: 20,
          )
        else
          Container()
      ],
    );
  }

  /// 유저 정보를 조회하여 멤버 변수 userProfileModel을 설정하는 함수.
  /// API 통신을 위해 userProvider 변수를 전달받음.
  /// API 통신 및 userProfileModel에 정보 저장이 모두 성공적일 경우 true.
  /// 아닌 경우 false 반환.
  Future<bool> _fetchUser(UserProvider userProvider) async {
    String apiUrl = "user_profiles/${widget.userID}";
    try {
      var response = await userProvider.getApiRes(apiUrl);
      final Map<String, dynamic>? json = await response?.data;
      try {
        _userProfileModel = PublicUserProfileModel.fromJson(json!);
        return true;
      } catch (error) {
        debugPrint("fetch user failed: ${widget.userID}");
      }
    } on DioException catch (e) {
      // 서버에서 response를 보냈지만 invalid한 statusCode일 때
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
      debugPrint("_fetchUser failed with error: $e");
    }
    return false;
  }

  /// 작성한 글 리스트를 불러와 멤버 변수 articleList에 저장하는 함수.
  /// API 통신을 위해 userProvider, _fetchCreatedArticles 호출을 위해 page를 전달받음
  /// API 통신 및 작성한 글 리스트 저장이 모두 성공할 경우 true. 아니면 false 반환.
  Future<bool> _fetchCreatedArticles(
      UserProvider userProvider, int page) async {
    int user = _userProfileModel.user;
    String apiUrl = "articles/?page=$page&created_by=$user";
    // 첫 페이지일 경우 기존에 존재하는 article을 모두 제거.
    if (page == 1) {
      _articleList.clear();
      _nextPage = 1;
    }
    try {
      var response = await userProvider.getApiRes(apiUrl);
      final Map<String, dynamic>? jsonList = await response?.data;
      List<dynamic> rawPostList = jsonList?['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        // 가끔 형식에 맞지 않은 데이터를 가진 글이 있어 추가함.(2023.05.26)
        if (rawPost == null) continue;
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
      _articleCount = jsonList?['num_items'];
      return true;
    } on DioException catch (e) {
      // 서버에서 response를 보냈지만 invalid한 statusCode일 때
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
      debugPrint("_fetchCreatedArticles failed with error: $e");
    }
    return false;
  }
}
