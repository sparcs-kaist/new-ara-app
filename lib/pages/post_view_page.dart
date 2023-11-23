/// post의 내용을 보여주는 페이지 전체를 관리하는 파일.
/// 뷰, 이벤트 처리 모두를 관리하고 있음.
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
import 'package:webview_flutter/webview_flutter.dart';

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

  /// 현재 사용자가 글을 신고할 수 있는 지 여부.
  /// initState에서 자신의 글일 경우 true, 아닐 경우 false로 설정됨.
  late bool _isReportable;

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
  FocusNode textFocusNode = FocusNode();

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
      _isReportable = value ? !_article.is_mine : false;
      _setIsPageLoaded(value);
    });

    // 페이지가 로드될 때 새로운 알림이 있는지 조회.
    context.read<NotificationProvider>().checkIsNotReadExist();
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
  /// _article, _commentList, _commentKeys의 값이 모두 설정되면 true, 아닌 경우 false 반환.
  Future<bool> _fetchArticle(UserProvider userProvider) async {
    dynamic articleJson;

    articleJson = await userProvider.getApiRes("articles/${widget.articleID}");
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

    // _fetchArticle이 진행중일 때는 Stack을 이용해 가림.
    // _fetchArticle이 끝났지만 웹뷰 로드가 끝나지 않았을 때는 조건문으로 가림.
    // 웹뷰 로드까지 완료되었을 때는 빌드된 Scaffold를 보여줌.
    // TODO: Stack 리팩토링
    return Stack(
      children: [
        if (_isPageLoaded)
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: ColorsInfo.newara,
                icon: SvgPicture.asset('assets/icons/left_chevron.svg',
                    color: ColorsInfo.newara, width: 35, height: 35),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                // 화면을 탭하면 키보드가 내려가도록 하기 위해 사용함.
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    // article 부분
                    Expanded(
                      child: RefreshIndicator(
                        color: ColorsInfo.newara,
                        onRefresh: () async {
                          userProvider.setIsContentLoaded(false);
                          _setIsPageLoaded(false);
                          _setIsPageLoaded(await _fetchArticle(userProvider));
                        },
                        child: SingleChildScrollView(
                          // 위젯이 화면을 넘어가지 않더라고 scrollable 처리.
                          // 새로고침 기능을 위한 physics.
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitle(),
                              const SizedBox(height: 10),
                              // 유저 정보 (프로필 이미지, 닉네임)
                              _buildAuthorInfo(userProvider),
                              const Divider(
                                thickness: 1,
                              ),
                              // TODO: (2023.08.09)첨부파일 리스트뷰 프로토타입. 추후 디자이너와 조율 예정
                              Visibility(
                                visible: _article.attachments.isNotEmpty,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AttachPopupMenuButton(
                                      fileNum: _article.attachments.length,
                                      attachments: _article.attachments,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              InArticleWebView(
                                content: _article.content ?? "",
                                initialHeight: 150,
                                isComment: false,
                              ),
                              const SizedBox(height: 10),
                              // 좋아요, 싫어요 버튼 Row
                              _buildVoteButtons(userProvider),
                              const SizedBox(height: 10),
                              // 담아두기, 공유, 신고 버튼
                              _buildUtilityButtons(userProvider),
                              const SizedBox(height: 15),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
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
                              _buildCommentListView(userProvider),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 댓글 입력 부분
                    _buildCommentTextFormField(userProvider),
                  ]),
                ),
              ),
            ),
          )
        else
          const LoadingIndicator(),
        // TODO: 아래 기능에 대해 디자이너와 논의 필요 (2023.11.03)
        // Visibility(
        //   visible: !(context.watch<UserProvider>().isContentLoaded),
        //   child: Container(color: Colors.white),
        // ),
      ],
    );
  }

  /// 제목, 날짜, 조회수, 좋아요, 싫어요, 댓글 표시
  /// 작성자 정보 상단까지의 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _article.title.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
                  getTime(_article.created_at),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(177, 177, 177, 1),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '조회 ${_article.hit_count}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(177, 177, 177, 1),
                  ),
                ),
              ],
            ),
            // 좋아요, 싫어요, 댓글 갯수 표시 Row
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/like.svg',
                  width: 13,
                  height: 15,
                  color: _article.my_vote == false
                      ? ColorsInfo.noneVote
                      : ColorsInfo.newara,
                ),
                const SizedBox(width: 3),
                Text('${_article.positive_vote_count}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _article.my_vote == false
                            ? ColorsInfo.noneVote
                            : ColorsInfo.newara)),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/dislike.svg',
                  width: 13,
                  height: 15,
                  color: _article.my_vote == true
                      ? ColorsInfo.noneVote
                      : ColorsInfo.negVote,
                ),
                const SizedBox(width: 3),
                Text('${_article.negative_vote_count}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _article.my_vote == true
                          ? ColorsInfo.noneVote
                          : ColorsInfo.negVote,
                    )),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/comment.svg',
                  width: 13,
                  height: 15,
                  color: const Color.fromRGBO(99, 99, 99, 1),
                ),
                const SizedBox(width: 3),
                Text('${_article.comment_count}',
                    style: const TextStyle(
                        fontSize: 14,
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
    return InkWell(
      // 익명일 경우 작성자 정보확인이 불가하도록 함.
      onTap: _article.name_type == 2
          ? null
          : () async {
              await Navigator.of(context).push(
                  slideRoute(UserViewPage(userID: _article.created_by.id)));
              // 유저 정보 페이지에서 돌아올 때 페이지를 업데이트함.
              _setIsPageLoaded(await _fetchArticle(userProvider));
            },
      child: Row(
        children: [
          // 사용자 프로필 사진.
          // 프로필 이미지 링크가 null일 경우 회색 바탕으로 표시함.
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
                size: const Size.fromRadius(30),
                child: Image.network(
                  fit: BoxFit.cover,
                  _article.created_by.profile.picture ?? "null",
                  // 정상적인 이미지 로드에 실패했을 경우
                  // warning 아이콘 표시하기
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    debugPrint("$error");
                    return SizedBox(
                      child: SvgPicture.asset(
                        "assets/icons/warning.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.black, BlendMode.srcIn,
                        ),
                        width: 25,
                        height: 25,
                      ),
                    );
                  },
                ),
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
            visible: _article.created_by.profile.nickname != "익명",
            child: SvgPicture.asset(
              'assets/icons/right_chevron.svg',
              color: Colors.black,
              width: 5,
              height: 9,
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
          onTap: () async {
            bool res = await ArticleController(
              model: _article,
              userProvider: userProvider,
            ).posVote();
            if (res) _updateState();
          },
          child: SvgPicture.asset(
            'assets/icons/like.svg',
            color: _article.my_vote == false
                ? ColorsInfo.noneVote
                : ColorsInfo.newara,
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 3),
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
          onTap: () {
            ArticleController(
              model: _article,
              userProvider: userProvider,
            ).negVote().then((result) {
              if (result) _updateState();
            });
          },
          child: SvgPicture.asset(
            'assets/icons/dislike.svg',
            color: _article.my_vote == true
                ? ColorsInfo.noneVote
                : ColorsInfo.negVote,
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 3),
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

  // TODO: 버튼 세부적인 다지인(아이콘 종류, 크기 등등) 조정 필요

  /// 담아두기, 공유, 신고 버튼 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _article 클래스 전역변수를 사용함.
  Widget _buildUtilityButtons(UserProvider userProvider) {
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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _article.my_scrap == null
                        ? const Color.fromRGBO(230, 230, 230, 1)
                        : ColorsInfo.newara,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        'assets/icons/bookmark.svg',
                        width: 15,
                        height: 15,
                        color: _article.my_scrap == null
                            ? const Color.fromRGBO(100, 100, 100, 1)
                            : ColorsInfo.newara,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _article.my_scrap == null ? '담아두기' : '담아둔 글',
                        style: TextStyle(
                          color: _article.my_scrap == null
                              ? Colors.black
                              : ColorsInfo.newara,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                await ArticleController(
                  model: _article,
                  userProvider: userProvider,
                ).share();
              },
              child: Container(
                width: 64,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromRGBO(230, 230, 230, 1),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        width: 11,
                        height: 25,
                        color: const Color.fromRGBO(100, 100, 100, 1),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '공유',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // 자신의 글일 경우 삭제 버튼, 타인의 글일 경우 차단 버튼
            if (_isReportable) // 신고가 가능한 글(타인의 글)
              InkWell(
                onTap: null,
                child: Container(
                  width: 65,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(230, 230, 230, 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/barrior.svg",
                          width: 11,
                          height: 13,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn)),
                      const Text(
                        '차단',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else // 자신의 글
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
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(230, 230, 230, 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/delete.svg",
                          width: 15,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn)),
                      const Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(width: 10),
            // 자신의 글일 경우 수정 버튼, 타인의 글일 경우 신고 버튼
            if (_isReportable) // 타인의 글(신고가 가능한 글)
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReportDialogWidget(articleID: _article.id);
                      });
                },
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(230, 230, 230, 1),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 2),
                        SvgPicture.asset(
                          'assets/icons/warning.svg',
                          width: 25,
                          height: 25,
                          color: const Color.fromRGBO(100, 100, 100, 1),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '신고',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else // 자신의 글
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
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(230, 230, 230, 1),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/modify.svg',
                          width: 11,
                          height: 13,
                        ),
                        const Text(
                          '수정',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
  Widget _buildCommentListView(UserProvider userProvider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 15),
      shrinkWrap: true, // 모든 댓글을 보여주는 선에서 크기를 최소화
      // SingleChildScrollView와의 충돌을 방지하기 위해서
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _commentList.length,
      itemBuilder: (BuildContext context, int idx) {
        CommentNestedCommentListActionModel curComment = _commentList[idx];
        // 각각의 댓글에 대한 컨테이너
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
                        onTap: curComment.name_type == 2
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserViewPage(
                                          userID: curComment.created_by.id)),
                                );
                              },
                        child: Row(
                          children: [
                            // 댓글 작성자 프로필 이미지 표시
                            // 이미지 링크가 null일 경우 회색 바탕으로 표시.
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child:
                                  curComment.created_by.profile.picture == null
                                      ? Container()
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(25),
                                            child: Image.network(
                                                fit: BoxFit.cover,
                                                curComment.created_by.profile
                                                    .picture!),
                                          ),
                                        ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 200,
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
                            Text(
                              getTime(curComment.created_at),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(51, 51, 51, 1)),
                            ),
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
                    child: curComment.is_hidden == false
                        ? _buildCommentContent(curComment.content ?? "")
                        : const Text(
                            '삭제된 댓글 입니다.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
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
                                onTap: () {
                                  CommentController(
                                    model: curComment,
                                    userProvider: userProvider,
                                  ).posVote().then((result) {
                                    if (result) _updateState();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/like.svg',
                                  width: 25,
                                  height: 25,
                                  color: curComment.my_vote == false
                                      ? ColorsInfo.noneVote
                                      : ColorsInfo.newara,
                                ),
                              ),
                              const SizedBox(width: 3),
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
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () async {
                                  CommentController(
                                    model: curComment,
                                    userProvider: userProvider,
                                  ).negVote().then((result) {
                                    if (result) _updateState();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/dislike.svg',
                                  width: 25,
                                  height: 25,
                                  color: curComment.my_vote == true
                                      ? ColorsInfo.noneVote
                                      : ColorsInfo.negVote,
                                ),
                              ),
                              const SizedBox(width: 3),
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
                                  height: 12,
                                ),
                                const SizedBox(width: 5),
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
            const Divider(),
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
    // HTML 태그가 존재하는지 검사 (완벽한 방법은 아님)
    if (!content.contains('<')) {
      return Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      );
    }
    return InArticleWebView(
      content: getContentHtml(content),
      initialHeight: 10,
      isComment: true,
    );
  }

  /// 댓글 입력창 빌드를 담당하며 빌드된 위젯을 리턴.
  /// targetComment, _isNestedComment, _isModify, _textEditingController 클래스 전역변수 사용.
  Widget _buildCommentTextFormField(UserProvider userProvider) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.0, color: Color(0x00F0F0F0)), // 원하는 색상과 두께로 설정
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
                Text(
                  '${(targetComment == null ? false : targetComment!.is_mine) ? '\'나\'에게' : "'${targetComment?.created_by.profile.nickname}'님께"} 답글을 작성하는 중',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5)
              ],
            ),
          ),
          Visibility(
            visible: _isModify,
            child: Column(
              children: [
                Text(
                  '나의 댓글 "${targetComment?.content}" 수정 중',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5)
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
                            color: ColorsInfo.newara,
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
                  constraints: const BoxConstraints(
                    minHeight: 45,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(235, 235, 235, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: _buildForm(),
                ),
              ),
              const SizedBox(width: 5),
              // send button
              AbsorbPointer(
                absorbing: _isSending,
                child: InkWell(
                  onTap: () async {
                    _setIsSending(true);
                    bool sendRes = await _sendComment(userProvider);
                    if (sendRes) {
                      _setIsPageLoaded(await _fetchArticle(userProvider));
                      debugPrint("Send Complete!");
                    } else {
                      debugPrint("Send Comment Failed");
                    }
                    _setIsSending(false);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    color: ColorsInfo.newara,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
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
            cursorColor: ColorsInfo.newara,
            controller: _textEditingController,
            focusNode: textFocusNode,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '댓글을 입력해주세요',
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
      var patchRes = await userProvider.patchApiRes(
        "comments/${targetComment!.id}/",
        payload: defaultPayload,
      );
      if (patchRes.statusCode != 200) {
        debugPrint("PATCH /api/comments/${targetComment!.id}/ failed");
        return false;
      }
      targetComment = null;
      _textEditingController.text = "";
      _setCommentMode(false, false);
    }
    return true;
  }
}
