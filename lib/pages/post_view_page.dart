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
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/utils/html_info.dart';
import 'package:new_ara_app/pages/user_view_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:new_ara_app/utils/post_view_utils.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/constants/file_type.dart';
import 'package:new_ara_app/widgetclasses/in_article_web_view.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

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

  late InArticleWebView inArticleWebView;

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
    // 페이지 로드 속도 향상을 위해 주석 처리.
    //context.read<NotificationProvider>().checkIsNotReadExist();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    // 웹뷰 로드는 다른 위젯이 로드되는 것보다 시간이 더 걸림.
    // 따라서 다른 위젯 로드를 완료할 때까지 LoadingIndicator를 보여줌.
    // 웹뷰를 로드하는 동안에는 Container를 보여줌.
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
                                    _buildAttachMenuButton(
                                        _article.attachments.length),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              //_buildArticleContent(userProvider),
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
                    _buildCommentTextField(userProvider),
                  ]),
                ),
              ),
            ),
          )
        else
          const LoadingIndicator(),
        Visibility(
          visible: !(context.watch<UserProvider>().isContentLoaded),
          child: const LoadingIndicator(),
        ),
      ],
    );
  }

  /// 글의 내용을 빌드하는 위젯
  /// Text 또는 InArticleWebView 위젯을 리턴.
  Widget _buildArticleContent(UserProvider userProvider) {
    if (_article.content == null) {
      return const Text(
        '내용이 없습니다.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      );
    } else {
      String content = _article.content!;
      if (content.contains('<')) {
        return InArticleWebView(
          content: content,
          initialHeight: 150.0,
          isComment: false,
        );
      } else {
        userProvider.setIsContentLoaded(true);
        return Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        );
      }
    }
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
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child:
                  Image.network(_article.created_by.profile.picture.toString()),
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
        InkWell(
          // TODO: 따로 빼서 메서드화하여 가독성 향상하기
          onTap: () async {
            bool res = await ArticleController(
              model: _article,
              userProvider: userProvider,
            ).posVote();
            if (res) updateState();
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
        InkWell(
          onTap: () {
            ArticleController(
              model: _article,
              userProvider: userProvider,
            ).negVote().then((result) {
              if (result) updateState();
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
                  if (result) updateState();
                });
              },
              child: Container(
                width: 100,
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
                        width: 25,
                        height: 25,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () async {
                await ArticleController(
                  model: _article,
                  userProvider: userProvider,
                ).share();
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
                        'assets/icons/share.svg',
                        width: 25,
                        height: 25,
                        color: const Color.fromRGBO(100, 100, 100, 1),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '공유',
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
        // TODO: collection if로 삼항연산자 대체하기
        // 자신의 글일 경우 수정 버튼, 타인의 글일 경우 신고 버튼
        _isReportable
            ? InkWell(
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
            : InkWell(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostWritePage(previousArticle: _article)));
                  userProvider.setIsContentLoaded(false);
                  _setIsPageLoaded(false);
                  _setIsPageLoaded(await _fetchArticle(userProvider));
                },
                child: Container(
                  width: 95,
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
                          width: 30,
                          height: 30,
                        ),
                        const Text(
                          '수정하기',
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
    );
  }

  /// 댓글 리스트 빌드를 담당하며 빌드된 위젯을 리턴.
  /// _commentList 클래스 전역변수를 사용함.
  Widget _buildCommentListView(UserProvider userProvider) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 15),
      shrinkWrap: true, // 모든 댓글을 보여주는 선에서 크기를 최소화
      // SingleChildScrollView와의 충돌을 방지하기 위해서
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _commentList.length,
      itemBuilder: (BuildContext context, int idx) {
        CommentNestedCommentListActionModel curComment = _commentList[idx];
        // 각각의 댓글에 대한 컨테이너
        return Container(
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
                        Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.network(curComment
                                .created_by.profile.picture
                                .toString()),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 200,
                            ),
                            child: Text(
                              curComment.created_by.profile.nickname.toString(),
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
                            ? _buildMyPopupMenuButton(
                                curComment.id, userProvider, idx)
                            : _buildOthersPopupMenuButton(curComment.id))),
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
                                if (result) updateState();
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
                                if (result) updateState();
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
                          moveCommentContainer(idx);
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
        );
      },
      separatorBuilder: (BuildContext context, int idx) => const Divider(),
    );
  }

  /// 댓글 입력창 빌드를 담당하며 빌드된 위젯을 리턴.
  /// targetComment, _isNestedComment, _isModify, _textEditingController 클래스 전역변수 사용.
  Widget _buildCommentTextField(UserProvider userProvider) {
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
                    setIsSending(true);
                    bool sendRes = await _sendComment(userProvider);
                    if (sendRes) {
                      _setIsPageLoaded(await _fetchArticle(userProvider));
                      debugPrint("Send Complete!");
                    } else {
                      debugPrint("Send Comment Failed");
                    }
                    setIsSending(false);
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

  /// 첨부파일명과 함께 파일 타입 사진을 보여주기 위해 사용.
  /// 파일 확장자를 ext를 통해 받은 후 해당하는 svg 이미지를 리턴.
  SvgPicture _getFileTypeImage(String ext) {
    late String assetPath;
    if (AttachFileType.imageExt.contains(ext)) {
      assetPath = "assets/icons/image.svg";
    } else if (AttachFileType.videoExt.contains(ext)) {
      assetPath = "assets/icons/video.svg";
    } else if (AttachFileType.docx == ext) {
      assetPath = "assets/icons/docx.svg";
    } else if (AttachFileType.pdf == ext) {
      assetPath = "assets/icons/pdf.svg";
    } else {
      assetPath = "assets/icons/clip.svg";
    }
    debugPrint(ext);
    return SvgPicture.asset(
      assetPath,
      color: Colors.black,
      width: 30,
      height: 30,
    );
  }

  /// 첨부파일 모아보기를 클릭하였을 때 나오는 PopupMenuButton.
  /// 파일의 갯수를 전달받고 클래스 멤버변수 _article의 attachments 속성에서 정보를 가져옴.
  PopupMenuButton<int> _buildAttachMenuButton(int fileNum) {
    return PopupMenuButton<int>(
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
        splashRadius: 5,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        padding: const EdgeInsets.all(2.0),
        child: Text(
          '첨부파일 모아보기 $fileNum',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        itemBuilder: (BuildContext context) {
          List<AttachmentModel> files = _article.attachments;
          return List.generate(
            files.length,
            (idx) {
              String fullFileName =
                  Uri.parse(files[idx].file).path.substring(7);
              int dotIndex = fullFileName.lastIndexOf(".");
              String fileName = dotIndex == -1
                  ? fullFileName
                  : fullFileName.substring(0, dotIndex - 1);
              String extension =
                  dotIndex == -1 ? "" : fullFileName.substring(dotIndex);
              return PopupMenuItem<int>(
                value: idx,
                child: Container(
                  padding: const EdgeInsets.only(left: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0x00FFFFFF),
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      _getFileTypeImage(extension.substring(1)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          fileName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        extension,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        onSelected: (int result) async {
          AttachmentModel model = _article.attachments[result];
          UserProvider userProvider = context.read<UserProvider>();
          bool res =
              await FileController(model: model, userProvider: userProvider)
                  .download();
          debugPrint(res ? "파일 다운로드 성공" : "파일 다운로드 실패");
        });
  }

  /// 자신의 댓글에 대한 수정, 삭제 버튼이 있는 PopupMenuButton
  /// 댓글 식별을 위한 [id], API 통신을 위한 [userProvider],
  /// 해당 댓글의 _commentList 내에서의 위치인 [idx]를 전달받음.
  PopupMenuButton<String> _buildMyPopupMenuButton(
      int id, UserProvider userProvider, int idx) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: const EdgeInsets.all(2.0),
      child: SvgPicture.asset(
        'assets/icons/menu_2.svg',
        color: Colors.grey,
        width: 50,
        height: 20,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Modify',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/modify.svg',
                width: 25,
                height: 25,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
              const SizedBox(width: 10),
              const Text(
                '수정',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 25,
                height: 25,
                color: ColorsInfo.newara,
              ),
              const SizedBox(width: 10),
              const Text(
                '삭제',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorsInfo.newara,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String result) async {
        switch (result) {
          case 'Modify':
            _textEditingController.text = _commentList[idx].content.toString();
            targetComment = _commentList[idx];
            _setCommentMode(false, true);
            textFocusNode.requestFocus();
            moveCommentContainer(idx);
            break;
          case 'Delete':
            showDialog(
              context: context,
              builder: (context) {
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
                          '정말로 이 댓글을 삭제하시겠습니까?',
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
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // 테두리 색상을 빨간색으로 지정
                                    width: 1, // 테두리의 두께를 2로 지정
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
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
                              onTap: () {
                                _delComment(id, userProvider).then((res) async {
                                  if (res == false) {
                                    return;
                                  } else {
                                    bool res =
                                        await _fetchArticle(userProvider);
                                    _setIsPageLoaded(res);
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
              },
            );
            break;
        }
      },
    );
  }

  /// 다른 유저의 댓글에 대해 채팅, 신고를 나타내는 PopupMenuButton
  /// 댓글의 id인 commentID를 전달받음.
  PopupMenuButton<String> _buildOthersPopupMenuButton(int commentID) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      padding: const EdgeInsets.all(2.0),
      child: SvgPicture.asset(
        'assets/icons/menu_2.svg',
        color: Colors.grey,
        width: 50,
        height: 20,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Chat',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/chat.svg',
                width: 20,
                height: 20,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
              const SizedBox(width: 10),
              const Text(
                '채팅',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Report',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/warning.svg',
                width: 20,
                height: 20,
                color: ColorsInfo.newara,
              ),
              const SizedBox(width: 10),
              const Text(
                '신고',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorsInfo.newara,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String result) {
        switch (result) {
          case 'Chat':
            // (2023.08.01) 채팅 기능은 추후에 구현 예정이기 때문에 아직은 Placeholder
            break;
          case 'Report':
            showDialog(
                context: context,
                builder: (context) {
                  return ReportDialogWidget(commentID: commentID);
                });
            break;
        }
      },
    );
  }

  /// 댓글 입력을 위한 Form을 생성하여 리턴함.
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

  /// 현재 댓글은 이미지, 링크가 있는 경우 HTML로 저장되어 있음.
  /// 그러나 텍스트만 있는 댓글도 다수 존재하여 HTML 태그를 감지하고 필요한 것들만
  /// 웹뷰로 로드, 나머지는 텍스트로 댓글을 로드하도록 함.
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
      isComment: false,
    );
  }

  /// 대댓글, 수정 기능 사용 시 대상이 되는 댓글 컨테이너를
  /// 키보드 바로 위로 이동시키는 메서드.
  /// 댓글 식별을 위해 _commentKeys의 인덱스를 [idx]로 전달받음.
  void moveCommentContainer(int idx) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_commentKeys[idx].currentContext == null ||
          _textFieldKey.currentContext == null) return;
      RenderBox commentBox =
          _commentKeys[idx].currentContext!.findRenderObject() as RenderBox;
      RenderBox textFieldBox =
          _textFieldKey.currentContext!.findRenderObject() as RenderBox;

      double commentHeight = commentBox.localToGlobal(Offset.zero).dy;
      double textFieldHeight = textFieldBox.localToGlobal(Offset.zero).dy;
      double diff = commentHeight - textFieldHeight;

      debugPrint("diff: $diff");
      if (diff > -15) {
        _scrollController.animateTo(
          _scrollController.position.pixels + diff + textFieldBox.size.height,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void setIsSending(bool value) {
    if (!mounted) return;
    setState(() => _isSending = value);
  }

  void updateState() {
    if (!mounted) return;
    setState(() {});
  }

  // isValid: article 에 적절한 정보가 있는지 나타냄
  void _setIsPageLoaded(bool value) {
    if (!mounted) return;
    setState(() => _isPageLoaded = value);
  }

  // 둘 다 false 면 일반적인 댓글
  void _setCommentMode(bool isNestedVal, bool isModifyVal) {
    if (!mounted) return;
    setState(() {
      _isNestedComment = isNestedVal;
      _isModify = isModifyVal;
    });
  }

  /// 댓글 삭제 기능을 위해 만들어진 메서드.
  /// 댓글 식별을 위한 [id], API 통신을 위한 [userProvider]를 전달받음.
  /// 댓글 삭제 API 요청이 성공하면 true, 그 외에는 false를 반환함.
  Future<bool> _delComment(int id, UserProvider userProvider) async {
    late dynamic delRes;
    try {
      delRes = await userProvider.delApiRes("comments/$id/");
    } catch (error) {
      debugPrint("DELETE /api/comments/$id failed: $error");
      return false;
    }
    if (delRes.statusCode != 204) {
      debugPrint("DELETE /api/comments/$id ${delRes.statusCode}");
      return false;
    }
    return true;
  }

  /// 클래스 멤버변수 _article, _commentList, _commentKeys의 값을 설정하는 메서드.
  /// API 통신을 위해 [userProvider]를 전달받음.
  /// _article, _commentList, _commentKeys의 값이 모두 설정되면 true, 아닌 경우 false 반환.
  Future<bool> _fetchArticle(UserProvider userProvider) async {
    dynamic articleJson, commentJson;

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
      commentJson = await userProvider.getApiRes("comments/${anc.id}");
      if (commentJson == null) continue;
      late CommentNestedCommentListActionModel tmpModel;

      // 댓글을 추가하는 과정
      try {
        // ArticleNestedCommentListActionModel 은 CommentNestedCommentListAction 의 모든 필드를 가지고 있음
        // 따라서 원래 댓글은 ArticleNestedCommentListActionModel 에 저장되고,
        // 대댓글을 CommentNestedCommentListActionModel 에 저장되지만 댓글도 CommentNestedCommentListActionModel 에 저장하여 더 편하게 함.
        tmpModel = CommentNestedCommentListActionModel.fromJson(commentJson);
        _commentList.add(tmpModel);
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

  /// 댓글을 POST 요청을 통해 작성하는 메서드.
  /// API 요청을 위해 [userProvider]를 이용.
  /// 댓글이 성공적으로 보내지면 true, 그렇지 않으면 false 반환.
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