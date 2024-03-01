// post의 내용을 보여주는 페이지 전체를 관리하는 파일.
// 뷰, 이벤트 처리 모두를 관리하고 있음.
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/article_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/widgets/dialogs.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/utils/html_info.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/pages/user_view_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:new_ara_app/utils/post_view_utils.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/widgets/in_article_web_view.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/widgets/pop_up_menu_buttons.dart';
import 'package:new_ara_app/utils/profile_image.dart';
import 'package:new_ara_app/utils/handle_hidden.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';
import 'package:new_ara_app/providers/blocked_provider.dart';

// TODO: Dio 사용방식 createDioWithHeaders~ 로 변경하기

/// 하나의 post에 대한 내용 뷰, 이벤트 처리를 모두 담당하는 StatefulWidget.
class PostViewPage extends StatefulWidget {
  /// 보여주고 싶은 대상 post의 id.
  final int articleID;
  const PostViewPage({super.key, required int id}) : articleID = id;

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  /// 각각의 댓글 컨테이너에 대한 GlobalKey를 저장하는 리스트.
  /// 해당 댓글에 다른 사용자가 답글을 작성하거나, 댓글 작성자가 수정하는 경우에
  /// 해당 댓글 컨테이너의를 키보드 바로 위로 위치 시키는 기능에서 사용됨.
  final List<GlobalKey> _commentKeys = [];

  /// 댓글 입력 TextField에 대한 GlobalKey.
  final GlobalKey _textFieldKey = GlobalKey();

  /// PostViewPage에서 표시할 글.
  late ArticleModel _article;

  /// 웹뷰를 제외한 페이지 전체에 대한 로드 완료 여부를 나타냄.
  late bool _isPageLoaded;

  /// 사용자가 댓글을 수정 중인 지에 대한 여부를 나타냄.
  /// 댓글을 수정 중이라면 true. 아닌 경우 false.
  late bool _isModify;

  /// 사용자가 대댓글을 작성하고 있는 지에 대한 여부를 나타냄.
  /// 대댓글을 작성 중이라면 true. 아닌 경우 false.
  late bool _isNestedComment;

  /// 현재 댓글 전송 중인지 여부를 나타냄.
  /// 댓글 전송 버튼 중복 클릭 방지를 위해 사용하는 변수.
  /// 현재 댓글을 전송 중이라면 true. 아닌 경우 false.
  late bool _isSending;

  /// 현재 페이지의 글에 달려있는 모든 댓글, 답글이 저장됨.
  late List<CommentNestedCommentListActionModel> _commentList;

  /// 댓글 입력 TextField에 입력되어있는 텍스트.
  /// 댓글 전송 시에 사용됨.
  String _commentContent = "";

  /// 댓글 입력 TextField에 대한 FocusNode.
  /// 답글 쓰기, 수정 버튼 클릭 시에 TextField에 자동으로 Focus를 주기 위해 사용됨.
  final FocusNode textFocusNode = FocusNode();

  /// 댓글 수정 혹은 대댓글을 전송할 경우 해당 댓글 모델을 의미.
  /// 새로운 댓글 작성의 경우 null로 설정됨.
  CommentNestedCommentListActionModel? targetComment;

  /// 댓글 입력 TextField에 대한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// SingleChildScrollView에 대한 ScrollController.
  /// 대댓글, 댓글 수정 시 해당 댓글 컨테이너의 스크롤 위치 조정에 사용됨.
  final ScrollController _scrollController = ScrollController();

  /// 댓글 입력 TextField에 대한 TextEditingController
  /// TextField의 텍스트 조정에 사용됨.
  /// 댓글 수정의 경우 수정할 댓글을 초기 텍스트로 설정하고
  /// 전송 버튼 클릭 시에는 TextField의 내용을 지워줌.
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isPageLoaded = false;
    _isModify = _isNestedComment = false;
    _isSending = false;
    _commentList = [];
    UserProvider userProvider = context.read<UserProvider>();
    userProvider.setIsContentLoaded(false, quiet: true);
    _fetchArticle(userProvider).then((value) {
      _setIsPageLoaded(value);
    });

    // 페이지가 로드될 때 새로운 알림이 있는지 조회.
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  /// 클래스 멤버변수 _article, _commentList, _commentKeys의 값을 설정하는 메서드.
  /// API 통신을 위해 [userProvider]를 전달받음.
  /// 기존에 차단된 글에서는 title, content 등이 null이지만 override_hidden이 true이면 원래 내용이 로드됨.
  /// _article, _commentList, _commentKeys의 값이 모두 설정되면 true, 아닌 경우 false 반환.
  Future<bool> _fetchArticle(UserProvider userProvider,
      {overrideHidden = false}) async {
    dynamic articleJson;
    String apiUrl = "$newAraDefaultUrl/api/articles/${widget.articleID}";
    // 차단된 유저의 글에 대한 내용을 로드하는 경우 주소를 수정함.
    if (overrideHidden) apiUrl += "/?override_hidden=true";

    try {
      var response =
          await userProvider.createDioWithHeadersForGet().get(apiUrl);
      articleJson = response.data;
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

      // fetch에 실패하는 경우 false 리턴
      return false;
    } catch (e) {
      debugPrint("error on fetching article: $e");
      return false;
    }

    if (articleJson == null) {
      debugPrint("\nArticleJson is null\n");
      return false;
    }
    try {
      _article = ArticleModel.fromJson(articleJson);
    } catch (error) {
      debugPrint(
          "ArticleModel.fromJson failed at articleID = ${widget.articleID}: $error");
      return false;
    }

    _commentList.clear();
    _commentKeys.clear();
    for (ArticleNestedCommentListAction anc in _article.comments) {
      // 댓글을 추가하는 과정
      try {
        // ArticleNestedCommentListActionModel 은 CommentNestedCommentListAction 의 모든 필드를 가지고 있음
        // 따라서 원래 댓글은 ArticleNestedCommentListActionModel 에 저장되고,
        // 대댓글을 CommentNestedCommentListActionModel 에 저장되지만 댓글도 CommentNestedCommentListActionModel 에 저장하여 더 편하게 함.
        _commentList
            .add(CommentNestedCommentListActionModel.fromJson(anc.toJson()));
        _commentKeys.add(GlobalKey());
      } catch (error) {
        debugPrint(
            "CommentNestedCommentListActionModel.fromJson failed at ID ${anc.id}: $error");
        return false;
      }

      // 대댓글을 추가하는 과정
      for (CommentNestedCommentListActionModel cnc in anc.comments) {
        try {
          _commentList.add(cnc);
          _commentKeys.add(GlobalKey());
        } catch (error) {
          debugPrint(
              "CommentNestedCommentListActionModel.fromJson failed at ID ${cnc.id}: $error\n");
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    BlockedProvider blockedProvider = context.watch<BlockedProvider>();

    // _fetchArticle이 진행중일 때는 Stack을 이용해 가림.
    // _fetchArticle이 끝났지만 웹뷰 로드가 끝나지 않았을 때는 조건문으로 가림.
    // 웹뷰 로드까지 완료되었을 때는 빌드된 Scaffold를 보여줌.
    // TODO: Stack 리팩토링
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              leadingWidth: 200,
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/left_chevron.svg',
                      colorFilter: const ColorFilter.mode(
                          ColorsInfo.newara, BlendMode.srcATop),
                      fit: BoxFit.fill,
                      width: 35,
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 29),
                      child: Text(
                        _isPageLoaded ? _article.parent_board.ko_name : "",
                        style: const TextStyle(
                          color: Color(0xFFED3A3A),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: _isPageLoaded
                ? SafeArea(
                    child: GestureDetector(
                      // 화면을 탭하면 키보드가 내려가도록 하기 위해 사용함.
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // article 부분
                            Expanded(
                              // Android, iOS 여부에 따라 다른 새로고침
                              child: RefreshIndicator.adaptive(
                                color: ColorsInfo.newara,
                                onRefresh: () async {
                                  userProvider.setIsContentLoaded(false);
                                  _setIsPageLoaded(false);
                                  _setIsPageLoaded(
                                      await _fetchArticle(userProvider));
                                },
                                child: SingleChildScrollView(
                                  // 위젯이 화면을 넘어가지 않더라고 scrollable 처리.
                                  // 새로고침 기능을 위한 physics.
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTitle(blockedProvider),
                                      const SizedBox(height: 10),
                                      // 유저 정보 (프로필 이미지, 닉네임)
                                      _buildAuthorInfo(userProvider),
                                      const Divider(
                                        color: Color(0xFFF0F0F0),
                                        thickness: 1,
                                      ),
                                      if (_article.parent_board.slug ==
                                          'portal-notice')
                                        InkWell(
                                          onTap: () {
                                            launchInBrowser(
                                                    _article.url.toString())
                                                .then((launchRes) {
                                              if (launchRes == false) {
                                                showInfoBySnackBar(context,
                                                    '브라우저로 URL을 열 수 없습니다.');
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            height: 85,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: const Color(0xFFDBDBDB),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0),
                                                  color: Color(0xFFA9A9A9),
                                                ),
                                              ],
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            padding: const EdgeInsets.only(
                                                left: 28,
                                                right: 28,
                                                top: 18,
                                                bottom: 18),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        _article.title
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF4A4A4A)),
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/icons/right_chevron.svg',
                                                      width: 15,
                                                      height: 25,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              Color(0xFF4A4A4A),
                                                              BlendMode.srcIn),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  _article.url.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Color(0xFF4A4A4A)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      // TODO: (2023.08.09)첨부파일 리스트뷰 프로토타입. 추후 디자이너와 조율 예정
                                      Visibility(
                                        visible:
                                            _article.attachments.isNotEmpty,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AttachPopupMenuButton(
                                              fileNum:
                                                  _article.attachments.length,
                                              attachments: _article.attachments,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      // 차단된 유저의 글에 대한 내용
                                      Visibility(
                                        // 차단이 되었고 사용자가 '숨긴내용 보기'를 누르지 않았을 때
                                        // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                                        visible: (_article
                                                        .can_override_hidden ==
                                                    true &&
                                                _article.is_hidden == true) ||
                                            (_isAnonymousIOS(_article) &&
                                                blockedProvider
                                                    .blockedAnonymousPostIDs
                                                    .contains(_article
                                                        .created_by.id
                                                        .toString())),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Color(0xfffafafa),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            height: 170,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/barrior.svg',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                Text(
                                                  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                                                  (_isAnonymousIOS(_article) &&
                                                          blockedProvider
                                                              .blockedAnonymousPostIDs
                                                              .contains(_article
                                                                  .created_by.id
                                                                  .toString()))
                                                      ? "차단한 사용자의 게시물입니다.\n"
                                                      : getAllHiddenReasons(
                                                              _article
                                                                  .why_hidden)
                                                          .join('\n'),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFF4A4A4A),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                                                  (_isAnonymousIOS(_article) &&
                                                          blockedProvider
                                                              .blockedAnonymousPostIDs
                                                              .contains(_article
                                                                  .created_by.id
                                                                  .toString()))
                                                      ? ""
                                                      : "(${getHiddenInfo(_article.why_hidden)})",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Color(0xFF4A4A4A),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // TODO: 지금은 내용, 댓글 일괄 적용이지만 댓글만 적용하는 것도 필요
                                                // 숨겨진 게시물이지만 사용자가 내용을 확인할 수 있는 경우
                                                Visibility(
                                                    visible: _article
                                                            .can_override_hidden ==
                                                        true,
                                                    child: Container(
                                                        width: 104,
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                            width: 1,
                                                            color: const Color(
                                                                0xFFDBDBDB),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await _fetchArticle(
                                                                userProvider,
                                                                overrideHidden:
                                                                    true);
                                                            _updateState();
                                                          },
                                                          child: const Center(
                                                            child: Text(
                                                              '숨긴내용 보기',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff4a4a4a),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        )))
                                              ],
                                            )),
                                      ),
                                      Visibility(
                                        // 차단이 되지 않았을 때 또는 사용자가 '숨긴내용 보기'를 눌렀을 때
                                        // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                                        visible: (_article.is_hidden == false &&
                                            !(_isAnonymousIOS(_article) &&
                                                blockedProvider
                                                    .blockedAnonymousPostIDs
                                                    .contains(_article
                                                        .created_by.id
                                                        .toString()))),
                                        child: InArticleWebView(
                                          content: _article.content ?? "",
                                          initialHeight: 150,
                                          isComment: false,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _buildVoteButtons(userProvider),
                                      const SizedBox(height: 10),
                                      // 담아두기, 공유, 신고 버튼
                                      _buildUtilityButtons(
                                          userProvider, blockedProvider),
                                      const SizedBox(height: 15),
                                      const Divider(
                                          thickness: 1,
                                          color: Color(0xFFF0F0F0)),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Text(
                                          '${_article.comment_count}개의 댓글',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      // 댓글을 보여주는 ListView.
                                      _buildCommentListView(
                                          userProvider, blockedProvider),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // 댓글 입력 부분
                            _buildCommentTextFormField(userProvider),
                          ],
                        ),
                      ),
                    ),
                  )
                : const LoadingIndicator())
      ],
    );
  }

  /// 제목, 날짜, 조회수, 좋아요, 싫어요, 댓글 표시
  /// 작성자 정보 상단까지의 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildTitle(BlockedProvider blockedProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              if (_article.parent_topic != null)
                TextSpan(
                  text: "[${_article.parent_topic!.ko_name}] ",
                  style: const TextStyle(
                    color: Color(0xFFED3A3A),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              TextSpan(
                // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                text: (_isAnonymousIOS(_article) &&
                        blockedProvider.blockedAnonymousPostIDs
                            .contains(_article.created_by.id.toString()))
                    ? "차단한 사용자의 게시물입니다."
                    : getTitle(_article.title, _article.is_hidden,
                        _article.why_hidden),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),
        // 날짜, 조회수, 좋아요, 싫어요, 댓글 수를 표시하는 Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 날짜, 조회수 표시 Row
            Row(
              children: [
                Text(
                  specificTime(_article.created_at),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '조회 ${_article.hit_count}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
              ],
            ),
            // 좋아요, 싫어요, 댓글 갯수 표시 Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildVoteIcons(
                    true, _article.my_vote, ColorsInfo.posVote, 10.08, 11),
                const SizedBox(width: 1.92),
                Text('${_article.positive_vote_count}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _article.my_vote == false
                            ? ColorsInfo.noneVote
                            : ColorsInfo.newara)),
                const SizedBox(width: 10),
                _buildVoteIcons(
                    false, _article.my_vote, ColorsInfo.negVote, 10.08, 11),
                const SizedBox(width: 1.92),
                Text('${_article.negative_vote_count}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _article.my_vote == true
                          ? ColorsInfo.noneVote
                          : ColorsInfo.negVote,
                    )),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/comment.svg',
                  width: 11.85,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(99, 99, 99, 1),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 1.92),
                Text('${_article.comment_count}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(99, 99, 99, 1))),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 작성자 정보 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildAuthorInfo(UserProvider userProvider) {
    debugPrint("**********************************************");
    debugPrint("BUILDAUTHORINFO INVOKED");
    debugPrint("**********************************************");
    return InkWell(
      // 익명일 경우 작성자 정보확인이 불가하도록 함.
      onTap: !isRegular(_article.name_type)
          ? null
          : () async {
              await Navigator.of(context).push(
                  slideRoute(UserViewPage(userID: _article.created_by.id)));
              debugPrint("**********************************************");
              debugPrint("RETURN TO POSTVIEWPAGE");
              debugPrint("**********************************************");
              // 유저 정보 페이지에서 돌아올 때 페이지를 업데이트함.
              _setIsPageLoaded(await _fetchArticle(userProvider));
            },
      child: Row(
        children: [
          // 사용자 프로필 사진.
          // 프로필 이미지 링크가 null일 경우 warning 아이콘 표시
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(15),
                // 이미지 링크를 확인한 후 null인 이미지는 warning.svg를 빌드
                child: buildProfileImage(
                    _article.created_by.profile.picture, 25, 25),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // 사용자 닉네임 텍스트 표시.
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 150),
              child: Text(
                _article.created_by.profile.nickname.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          const SizedBox(width: 10),
          // 익명일 경우 작성자 정보 확인을 불가하도록 함.
          Visibility(
            visible: isRegular(_article.name_type),
            child: SvgPicture.asset(
              'assets/icons/right_chevron.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              width: 6,
              height: 15,
            ),
          ),
        ],
      ),
    );
  }

  /// 좋아요, 싫어요 버튼 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildVoteButtons(UserProvider userProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 좋아요 버튼
        InkWell(
          // TODO: onTap 메서드 함수로 빼놓기
          onTap: () async {
            // 자신의 글에는 요청을 보내지 않고 미리 차단하기
            if (_article.is_mine) {
              showInfoBySnackBar(context, "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다.");
              return;
            }
            // 다른 사람의 글인 경우
            else {
              // 원래의 상태를 보관하기 위해 임시 모델 생성
              ArticleModel tmpArticle =
                  ArticleModel.fromJson(_article.toJson());
              ArticleController(model: _article, userProvider: userProvider)
                  .setVote(true);
              _updateState();
              bool res = await ArticleController(
                model: tmpArticle,
                userProvider: userProvider,
              ).posVote();
              debugPrint('좋아요 결과 $res');
              if (!res) {
                ArticleController(model: _article, userProvider: userProvider)
                    .setVote(true);
                _updateState();
              }
            }
          },
          child: _buildVoteIcons(
              true, _article.my_vote, ColorsInfo.posVote, 20.17, 22),
        ),
        const SizedBox(width: 4),
        Text('${_article.positive_vote_count}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: _article.my_vote == false
                  ? ColorsInfo.noneVote
                  : ColorsInfo.posVote,
            )),
        const SizedBox(width: 20),
        // 싫어요 버튼
        InkWell(
          // TODO: onTap 메서드 함수화하기
          onTap: () async {
            if (_article.is_mine) {
              showInfoBySnackBar(context, "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다.");
              return;
            } else {
              ArticleModel tmpArticle =
                  ArticleModel.fromJson(_article.toJson());
              ArticleController(model: _article, userProvider: userProvider)
                  .setVote(false);
              _updateState();
              bool res = await ArticleController(
                model: tmpArticle,
                userProvider: userProvider,
              ).negVote();
              debugPrint('싫어요 결과 $res');
              if (!res) {
                ArticleController(model: _article, userProvider: userProvider)
                    .setVote(false);
                _updateState();
              }
            }
          },
          child: _buildVoteIcons(
              false, _article.my_vote, ColorsInfo.negVote, 20.17, 22),
        ),
        const SizedBox(width: 4),
        Text('${_article.negative_vote_count}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: _article.my_vote == true
                  ? ColorsInfo.noneVote
                  : ColorsInfo.negVote,
            )),
      ],
    );
  }

  /// 좋아요, 싫어요 아이콘을 모델의 상태에 알맞게 색상, filled 여부를 지정하여 리턴하는 함수
  /// isPositive가 true면 좋아요 아이콘, false면 싫어요 아이콘을 설정함
  /// highlightColor는 아이콘이 클릭되었을 때 지정되는 색상을 의미하며
  /// width, height는 아이콘의 크기를 지정하기 위해 사용됨.
  /// PostViewPage에서 화면 상단 및 댓글 위의 좋아요, 싫어요 아이콘 설정을 위해 사용됨.
  Widget _buildVoteIcons(bool isPositive, bool? myVote, Color highlightColor,
      double width, double height) {
    late Color widgetColor;
    late String iconPath;
    // 투표한 반대 위젯을 설정하는 경우
    if (myVote == !isPositive) {
      widgetColor = ColorsInfo.noneVote;
      iconPath = 'assets/icons/${isPositive ? 'like.svg' : 'dislike.svg'}';
    } else {
      widgetColor = highlightColor;
      // 투표하지 않은 경우
      if (myVote == null) {
        iconPath = 'assets/icons/${isPositive ? 'like.svg' : 'dislike.svg'}';
      } else {
        iconPath =
            'assets/icons/${isPositive ? 'like-filled.svg' : 'dislike-filled.svg'}';
      }
    }
    return SvgPicture.asset(iconPath,
        colorFilter: ColorFilter.mode(widgetColor, BlendMode.srcIn),
        width: width,
        height: height);
  }

  // TODO: 버튼 세부적인 다지인(아이콘 종류, 크기 등등) 조정 필요

  /// 담아두기, 공유, 신고 버튼 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildUtilityButtons(
      UserProvider userProvider, BlockedProvider blockedProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 담아두기,공유 버튼 Row
        Row(
          children: [
            InkWell(
              onTap: () {
                ArticleController(
                  model: _article,
                  userProvider: userProvider,
                ).scrap().then((result) {
                  if (result) _updateState();
                });
              },
              child: Container(
                width: 88,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _article.my_scrap == null
                        ? const Color(0xFFF0F0F0)
                        : ColorsInfo.newara,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/bookmark.svg',
                      width: 15,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                          _article.my_scrap == null
                              ? const Color(0xFF646464)
                              : ColorsInfo.newara,
                          BlendMode.srcIn),
                    ),
                    //const SizedBox(width: 4),
                    Text(
                      _article.my_scrap == null ? '담아두기' : '담아둔 글',
                      style: TextStyle(
                        color: _article.my_scrap == null
                            ? const Color(0xFF646464)
                            : ColorsInfo.newara,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              // TODO: onTap 함수화하기
              onTap: () {
                ArticleController(
                  model: _article,
                  userProvider: userProvider,
                ).share().then((_) {
                  hideOldsAndShowAraSnackBar(
                      context,
                      buildAraSnackBar(context,
                          duration: const Duration(seconds: 1),
                          content: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/close-1.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.red, BlendMode.srcIn),
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  "URL을 클립 보드에 복사했습니다.",
                                  // 오버플로우 나면 다음줄로 넘어가도록 하기 위해
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          )));
                });
              },
              child: Container(
                width: 64,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/share.svg',
                      width: 19,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(100, 100, 100, 1), BlendMode.srcIn),
                    ),
                    //const SizedBox(width: 6),
                    const Text(
                      '공유',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF646464),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // 자신의 글일 경우 삭제 버튼, 타인의 글일 경우 차단 버튼
            // 익명인 경우 자신의 글이 아니면 버튼이 표시되지 않음.
            // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
            if (_article.is_mine == false &&
                (_article.name_type == 1 || _isAnonymousIOS(_article)))
              InkWell(
                onTap: () async {
                  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                  if (_isAnonymousIOS(_article)) {
                    // 이미 차단한 경우
                    if (blockedProvider.blockedAnonymousPostIDs
                        .contains(_article.created_by.id.toString())) {
                      await blockedProvider.removeBlockedAnonymousPostID(
                          _article.created_by.id.toString());
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => BlockConfirmDialog(
                          onTap: () {
                            blockedProvider
                                .addBlockedAnonymousPostID(
                                    _article.created_by.id.toString())
                                .then((_) => Navigator.pop(context));
                          },
                          userProvider: userProvider,
                          targetContext: context,
                        ),
                      );
                    }
                    return;
                  }
                  // name_type == 1인 경우
                  bool isAuthorBlocked = _isAuthorBlocked();
                  // 차단되지 않은 경우
                  if (!isAuthorBlocked) {
                    await showDialog(
                      context: context,
                      builder: (context) => BlockConfirmDialog(
                        onTap: () {
                          ArticleController(
                                  model: _article, userProvider: userProvider)
                              .handleBlock(true)
                              .then((blockRes) {
                            // 차단이 성공한 경우
                            if (blockRes) {
                              _fetchArticle(userProvider).then((_) {
                                _updateState();
                                Navigator.pop(context);
                              });
                            }
                            // 차단에 실패할 경우 오류 메시지, 스낵바 출력
                            else {
                              debugPrint("failed to block");
                              Navigator.pop(context);
                              showInfoBySnackBar(context, "차단에 실패했습니다.");
                            }
                          });
                        },
                        userProvider: userProvider,
                        targetContext: context,
                      ),
                    );
                  }
                  // 이미 차단 되어있는 경우
                  else {
                    bool unblockRes = await ArticleController(
                            model: _article, userProvider: userProvider)
                        .handleBlock(false);
                    // 차단 해제에 성공한 경우 다시 글을 fetch함.
                    if (unblockRes) {
                      await _fetchArticle(userProvider);
                      _updateState();
                    }
                    // 차단 해제에 실패한 경우 오류 메시지를 출력함.
                    else {
                      // TODO: 사용자 메시지 구현 필요
                      debugPrint("Failed to unblock");
                    }
                  }
                },
                child: Container(
                  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                  width: (_isAuthorBlocked() ||
                          (Platform.isIOS &&
                              blockedProvider.blockedAnonymousPostIDs
                                  .contains(_article.created_by.id.toString())))
                      ? 85
                      : 65,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/barrior.svg",
                            width: 11,
                            height: 19,
                            colorFilter: const ColorFilter.mode(
                                Color(0xFF646464), BlendMode.srcIn)),
                        const SizedBox(width: 3),
                        Text(
                          // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                          (_isAuthorBlocked() ||
                                  (Platform.isIOS &&
                                      blockedProvider.blockedAnonymousPostIDs
                                          .contains(_article.created_by.id
                                              .toString())))
                              ? '차단 해제'
                              : '차단',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF646464)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_article.is_mine == true) // 자신의 글
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                            userProvider: userProvider,
                            targetContext: context,
                            onTap: () {
                              ArticleController(
                                      model: _article,
                                      userProvider: userProvider)
                                  .delete()
                                  .then((res) {
                                // 사용자가 미리 뒤로가기 버튼을 누르는 경우 에러 방지를 위해
                                // try-catch 문을 도입함.
                                try {
                                  // dialog pop
                                  Navigator.pop(context);
                                  if (res == true) {
                                    // PostViewPage pop
                                    Navigator.pop(context);
                                  }
                                } catch (error) {
                                  debugPrint("pop error: $error");
                                }
                              });
                            },
                          ));
                },
                child: Container(
                  width: 65,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/delete.svg",
                          width: 15,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                              Color(0xFF646464), BlendMode.srcIn)),
                      const Text(
                        '삭제',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF646464)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(width: 10),
            // 자신의 글일 경우 수정 버튼, 타인의 글일 경우 신고 버튼
            if (_article.is_mine == false) // 타인의 글(신고가 가능한 글)
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReportDialogWidget(articleID: _article.id);
                      });
                },
                child: Container(
                  width: 65,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/warning.svg',
                        width: 19,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF646464), BlendMode.srcIn),
                      ),
                      const Text(
                        '신고',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF646464)),
                      ),
                    ],
                  ),
                ),
              )
            // 자신의 글이며 숨겨지지 않았을 때
            else if (_article.is_hidden == false)
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                      slideRoute(PostWritePage(previousArticle: _article)));
                  userProvider.setIsContentLoaded(false);
                  _setIsPageLoaded(false);
                  _setIsPageLoaded(await _fetchArticle(userProvider));
                },
                child: Container(
                  width: 65,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/modify.svg',
                        width: 15,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF646464),
                          BlendMode.srcIn,
                        ),
                      ),
                      const Text(
                        '수정',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF646464)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// 댓글 리스트 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _commentList 클래스 전역변수를 사용함.
  Widget _buildCommentListView(
      UserProvider userProvider, BlockedProvider blockedProvider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 15),
      shrinkWrap: true, // 모든 댓글을 보여주는 선에서 크기를 최소화
      // SingleChildScrollView와의 충돌을 방지하기 위해서
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _commentList.length,
      itemBuilder: (BuildContext context, int idx) {
        CommentNestedCommentListActionModel curComment = _commentList[idx];
        // 각각의 댓글에 대한 컨테이너
        // TODO: is_hidden && can_override_hidden 인 경우 댓글 내용 확인이 가능하게 해야함.
        return Column(
          children: [
            Container(
              key: _commentKeys[idx],
              margin: EdgeInsets.only(
                  left: (curComment.parent_comment == null ? 0 : 30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        // 익명일 경우 댓글 작성자 정보 확인이 불가능하도록 함.
                        onTap: !isRegular(curComment.name_type)
                            ? null
                            : () {
                                Navigator.of(context).push(slideRoute(
                                    UserViewPage(
                                        userID: curComment.created_by.id)));
                              },
                        child: Row(
                          children: [
                            // 댓글 작성자 프로필 이미지 표시
                            // 이미지 링크가 null일 경우 warning 아이콘 표시
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(12.5),
                                  // 이미지 링크를 확인한 후 null인 이미지는 warning.svg를 빌드
                                  child: buildProfileImage(
                                      curComment.created_by.profile.picture,
                                      20,
                                      20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 250,
                                ),
                                child: Text(
                                  curComment.created_by.profile.nickname
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            const SizedBox(width: 7),
                            Text(getTime(curComment.created_at),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFBBBBBB),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 25,
                        child: Visibility(
                            visible: !(curComment.is_hidden),
                            child: (curComment.is_mine == true
                                ? MyPopupMenuButton(
                                    commentID: curComment.id,
                                    userProvider: userProvider,
                                    commentIdx: idx,
                                    onSelected: (String result) async {
                                      switch (result) {
                                        case 'Modify':
                                          _textEditingController.text =
                                              _commentList[idx]
                                                  .content
                                                  .toString();
                                          targetComment = _commentList[idx];
                                          _setCommentMode(false, true);
                                          textFocusNode.requestFocus();
                                          _moveCommentContainer(idx);
                                          break;
                                        case 'Delete':
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteDialog(
                                                userProvider: userProvider,
                                                targetContext: context,
                                                onTap: () {
                                                  CommentController(
                                                          model: curComment,
                                                          userProvider:
                                                              userProvider)
                                                      .delComment(curComment.id,
                                                          userProvider)
                                                      .then((res) async {
                                                    if (res) {
                                                      bool res =
                                                          await _fetchArticle(
                                                              userProvider);
                                                      _setIsPageLoaded(res);
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          );
                                          break;
                                      }
                                    })
                                : OthersPopupMenuButton(
                                    commentID: curComment.id))),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 0),
                    child: (_isAnonymousIOS(_article) &&
                            blockedProvider.blockedAnonymousPostIDs
                                .contains(curComment.created_by.id.toString()))
                        ? const Text(
                            "차단한 사용자의 댓글입니다.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          )
                        : (curComment.is_hidden == false
                            ? _buildCommentContent(curComment.content ?? "")
                            : Text(
                                getHiddenCommentReasons(curComment.why_hidden),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              )),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        // 삭제된 댓글의 경우 좋아요, 싫어요 버튼이 안보이게함.
                        Visibility(
                          visible: curComment.is_hidden == false,
                          child: Row(
                            children: [
                              InkWell(
                                // onTap 메서드 함수화하기
                                onTap: () async {
                                  if (curComment.is_mine) {
                                    showInfoBySnackBar(context,
                                        "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다.");
                                    return;
                                  } else {
                                    CommentNestedCommentListActionModel
                                        tmpCurComment =
                                        CommentNestedCommentListActionModel
                                            .fromJson(curComment.toJson());
                                    CommentController(
                                            model: curComment,
                                            userProvider: userProvider)
                                        .setVote(true);
                                    _updateState();
                                    bool res = await CommentController(
                                      model: tmpCurComment,
                                      userProvider: userProvider,
                                    ).posVote();
                                    debugPrint('좋아요 결과 $res');
                                    if (!res) {
                                      CommentController(
                                              model: curComment,
                                              userProvider: userProvider)
                                          .setVote(true);
                                      _updateState();
                                    }
                                  }
                                },
                                child: _buildVoteIcons(true, curComment.my_vote,
                                    ColorsInfo.posVote, 16, 17),
                              ),
                              const SizedBox(width: 2.19),
                              Text(
                                curComment.positive_vote_count.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: curComment.my_vote == false
                                      ? ColorsInfo.noneVote
                                      : ColorsInfo.posVote,
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                // API 요청 이전에 먼저 state를 변경한 뒤에 요청 결과에 따라 처리하기
                                onTap: () async {
                                  // onTap 메서드 함수화하기
                                  if (curComment.is_mine) {
                                    showInfoBySnackBar(context,
                                        "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다.");
                                    return;
                                  } else {
                                    // 원래 모델값을 저장하기 위해 임시 모델 생성
                                    CommentNestedCommentListActionModel
                                        tmpCurComment =
                                        CommentNestedCommentListActionModel
                                            .fromJson(curComment.toJson());
                                    CommentController(
                                            model: curComment,
                                            userProvider: userProvider)
                                        .setVote(false);
                                    _updateState();
                                    bool res = await CommentController(
                                      model: tmpCurComment,
                                      userProvider: userProvider,
                                    ).negVote();
                                    debugPrint('좋아요 결과 $res');
                                    if (!res) {
                                      CommentController(
                                              model: curComment,
                                              userProvider: userProvider)
                                          .setVote(false);
                                      _updateState();
                                    }
                                  }
                                },
                                child: _buildVoteIcons(
                                    false,
                                    curComment.my_vote,
                                    ColorsInfo.negVote,
                                    16,
                                    17),
                              ),
                              const SizedBox(width: 2.19),
                              Text(
                                curComment.negative_vote_count.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: curComment.my_vote == true
                                      ? ColorsInfo.noneVote
                                      : ColorsInfo.negVote,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 대댓글인 경우 답글쓰기 버튼이 안보이게함.
                        Visibility(
                          visible: curComment.parent_comment == null,
                          child: InkWell(
                            onTap: () {
                              targetComment = curComment;
                              _setCommentMode(true, false);
                              textFocusNode.requestFocus();
                              _moveCommentContainer(idx);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/right_arrow_2.svg',
                                  width: 11,
                                  height: 19,
                                ),
                                const Text(
                                  '답글 쓰기',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFF0F0F0)),
          ],
        );
      },
    );
  }

  /// 현재 댓글은 이미지, 링크가 있는 경우 HTML로 저장되어 있음.
  /// 그러나 텍스트만 있는 댓글도 다수 존재하여 HTML 태그를 감지하고 필요한 것들만
  /// 웹뷰로 로드, 나머지는 텍스트로 댓글을 로드하도록 함.
  /// _buildCommentListView에서 사용함.
  Widget _buildCommentContent(String content) {
    // html 태그에서 사용하는 '<', '>'의 경우 형태가 그대로 저장됨
    // html 태그가 아닌 '<', '>'의 경우 '&lt;', '&gt;'로 인코딩되어 저장됨
    // 따라서 위 두 가지 경우에 대해서는 웹뷰로 로드하고 나머지는 Text 위젲 사용.
    if ((content.contains('<') && content.contains('>')) ||
        content.contains('&lt;') ||
        content.contains('&gt;')) {
      return InArticleWebView(
        content: getContentHtml(content),
        initialHeight: 10,
        isComment: true,
      );
    }
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF4A4A4A),
      ),
    );
  }

  /// 댓글 입력창 빌드를 담당하며 빌드된 위젯을 리턴.
  /// targetComment, _isNestedComment, _isModify, _textEditingController 클래스 전역변수 사용.
  Widget _buildCommentTextFormField(UserProvider userProvider) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.0, color: Color(0xFFF0F0F0)), // 원하는 색상과 두께로 설정
        ),
      ),
      child: Column(
        key: _textFieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isNestedComment,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Text(
                  '${(targetComment == null ? false : targetComment!.is_mine) ? '\'나\'에게' : "'${targetComment?.created_by.profile.nickname}'님께"} 답글을 작성하는 중',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4)
              ],
            ),
          ),
          Visibility(
            visible: _isModify,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Text(
                  '나의 댓글 "${targetComment?.content}" 수정 중',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4)
              ],
            ),
          ),
          Row(
            children: [
              // Close button
              Visibility(
                visible: (_isModify || _isNestedComment),
                child: Row(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _textEditingController.text = "";
                            targetComment = null;
                            debugPrint("Parent Comment null");
                            _setCommentMode(false, false);
                          },
                          child: SvgPicture.asset(
                            'assets/icons/close-2.svg',
                            width: 30,
                            height: 30,
                            colorFilter: const ColorFilter.mode(
                                ColorsInfo.newara, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // TextFormField
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 7),
                  constraints: const BoxConstraints(
                    minHeight: 36,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: _buildForm(),
                ),
              ),
              const SizedBox(width: 12),
              // send button
              AbsorbPointer(
                absorbing: _isSending,
                child: InkWell(
                  onTap: () async {
                    _setIsSending(true);
                    bool sendRes = await _sendComment(userProvider);
                    if (sendRes) {
                      _setIsPageLoaded(await _fetchArticle(userProvider));
                      // 댓글은 페이지 최하단에 추가되므로 댓글 위치로 이동함.
                      // 댓글 수정, 대댓글은 제외
                      if (!_isNestedComment && !_isModify) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 72,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      }
                      debugPrint("Send Complete!");
                    } else {
                      debugPrint("Send Comment Failed");
                    }
                    _setIsSending(false);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    colorFilter: const ColorFilter.mode(
                        ColorsInfo.newara, BlendMode.srcIn),
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }

  /// 댓글 입력을 위한 Form을 생성하여 리턴함.
  /// _buildCommentTextFormField 함수에서 사용함.
  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 14,
            ),
            cursorColor: ColorsInfo.newara,
            controller: _textEditingController,
            focusNode: textFocusNode,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '댓글을 입력해주세요',
              hintStyle: TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '댓글이 작성되지 않았습니다!';
              }
              return null;
            },
            onChanged: (value) => _commentContent = value,
            onSaved: (value) => _commentContent = value ?? '',
          )),
    );
  }

  /// 현재 post의 작성자가 사용자에 의해 차단되었는지 여부를 반환
  /// created_by의 is_blocked 필드가 null이면 false 리턴.
  bool _isAuthorBlocked() {
    return _article.created_by.is_blocked ?? false;
  }

  /// 대댓글, 수정 기능 사용 시 대상이 되는 댓글 컨테이너를
  /// 키보드 바로 위로 이동시키는 메서드.
  /// 댓글 식별을 위해 _commentKeys의 인덱스를 [idx]로 전달받음.
  void _moveCommentContainer(int idx) {
    // 키보드가 화면에 나타나기까지 대기(0.5초로 설정함)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_commentKeys[idx].currentContext == null ||
          _textFieldKey.currentContext == null) return;
      // 댓글 컨테이너가 있는 위치
      RenderBox commentBox =
          _commentKeys[idx].currentContext!.findRenderObject() as RenderBox;
      // 댓글 입력창이 있는 위치
      RenderBox textFieldBox =
          _textFieldKey.currentContext!.findRenderObject() as RenderBox;

      double commentHeight = commentBox.localToGlobal(Offset.zero).dy;
      double textFieldHeight = textFieldBox.localToGlobal(Offset.zero).dy;
      double diff = commentHeight - textFieldHeight;

      debugPrint("diff: $diff");
      // 댓글이 키보드로 가려지는 경우 이동.
      if (diff > -15) {
        _scrollController.animateTo(
          _scrollController.position.pixels + diff + textFieldBox.size.height,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// _isSending의 값을 수정하고 state를 업데이트함.
  void _setIsSending(bool value) {
    if (!mounted) return;
    setState(() => _isSending = value);
  }

  // _isPageLoaded: article 에 적절한 정보가 있는지 나타냄
  void _setIsPageLoaded(bool value) {
    if (!mounted) return;
    setState(() => _isPageLoaded = value);
  }

  void _updateState() {
    if (!mounted) return;
    setState(() {});
  }

  // 둘 다 false 면 일반적인 댓글
  void _setCommentMode(bool isNestedVal, bool isModifyVal) {
    if (!mounted) return;
    setState(() {
      _isNestedComment = isNestedVal;
      _isModify = isModifyVal;
    });
  }

  /// 댓글을 POST 요청을 통해 작성하는 메서드.
  /// API 요청을 위해 [userProvider]를 이용.
  /// 댓글이 성공적으로 보내지면 true, 그렇지 않으면 false 반환.
  /// PostViewPage와 크게 연관되어 있어 CommentController로 이동시키지 않고 남김.
  Future<bool> _sendComment(UserProvider userProvider) async {
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return false;
    }
    _formKey.currentState!.save();
    if (!_isModify) {
      dynamic defaultPayload = {
        "content": _commentContent,
        "name_type": _article.name_type,
        "attachment": null,
      };
      defaultPayload.addAll(targetComment != null
          ? {"parent_comment": targetComment!.id}
          : {"parent_article": _article.id});
      var postRes = await userProvider.postApiRes(
        'comments/',
        payload: defaultPayload,
      );
      if (postRes.statusCode != 201) {
        // 나중에 사용자용 알림 기능 추가해야 함
        debugPrint("POST /api/comments failed");
        return false;
      }
      targetComment = null;
      _textEditingController.text = "";
      _setCommentMode(false, false);
    } else {
      dynamic defaultPayload = {
        "content": _commentContent,
        "is_mine": true,
        "name_type": _article.name_type,
      };
      Response? patchRes = await userProvider.patchApiRes(
        "comments/${targetComment!.id}/",
        payload: defaultPayload,
      );
      if (patchRes != null && patchRes.statusCode != 200) {
        debugPrint("PATCH /api/comments/${targetComment!.id}/ failed");
        return false;
      }
      targetComment = null;
      _textEditingController.text = "";
      _setCommentMode(false, false);
    }
    return true;
  }

  // TODO: in_article_web_view.dart의 함수와 통합 고려해보기

  /// _article.url (포탈공지글일 경우 포탈 링크가 있음)을
  /// 브라우저로 띄워주는 함수
  /// 브라우저로 url 열기에 성공하면 true, 아니면 false를 반환함.
  Future<bool> launchInBrowser(String url) async {
    final Uri targetUrl = Uri.parse(url);
    if (!await canLaunchUrl(targetUrl)) {
      debugPrint("$url을 열 수 없습니다.");
      return false;
    }
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not launch $url');
      return false;
    }

    return true;
  }

  /// 주어진 nameType에 따라 유저 정보를 볼 수 있는지 여부를 리턴하는 함수
  /// PostViewPage에서 UserViewPage로 리다이렉트 될 수 있는지 여부를 나타냄.
  bool isRegular(int? nameType) {
    return nameType == 1;
  }

  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
  /// 익명게시글에 차단 버튼을 표시해야하는지 여부를 나타냄(iOS 리젝을 피하기 위해 iOS 환경에서 익명 게시글일 때만 true 반환)
  bool _isAnonymousIOS(ArticleModel article) {
    return (Platform.isIOS && article.name_type == 2);
  }
}
